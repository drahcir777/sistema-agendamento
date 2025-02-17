class AppointmentsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :new, :create, :show, :edit, :update, :destroy, :by_phone, :available_dates_and_times ]
  before_action :set_appointment, only: [ :show, :edit, :update, :destroy ]
  before_action :set_professional, only: [ :new, :create ]

  def index
    if user_signed_in?
      if current_user.admin?
        @appointments = Appointment.all
      else
        @appointments = current_user.appointments_as_client
      end
    else
      @appointments = Appointment.none
    end
  end

  def new
    @appointment = Appointment.new
    @professionals = User.professionals

    # Carrega as datas disponíveis tanto para admin quanto para cliente não logado
    if params[:user_id]
      @professional = User.find(params[:user_id])
    else
      @professional = User.professionals.first
    end

    # Carrega as datas disponíveis iniciais
    @available_dates = @professional.disponibilidades
                                  .pluck(:data)
                                  .uniq
                                  .sort if @professional
  end

  def create
    @professional = User.find(appointment_params[:user_id])
    datetime_params = appointment_params.to_h

    if datetime_params[:date].present? && datetime_params[:time].present?
      date = Date.parse(datetime_params[:date])
      time = Time.parse(datetime_params[:time])

      # Cria o datetime usando Time.zone para respeitar o timezone
      datetime_params[:date] = Time.zone.local(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.min
      )
    end

    @appointment = @professional.appointments_as_professional.new(datetime_params)
    @appointment.client = find_or_create_client
    @appointment.status = "pending"

    if @appointment.valid?
      if @appointment.save
        # Gera a URL de confirmação após ter o ID do agendamento
        confirmation_url = confirm_appointment_url(@appointment)

        message = [
          "Olá #{@professional.name},",
          "#{@appointment.client.name} deseja agendar um horário para #{datetime_params[:date].strftime('%d/%m/%Y às %H:%M')}.",
          "",
          "Para confirmar, acesse o link abaixo:"
        ].join("\n")

        # Envia mensagem para o profissional com o link de confirmação
        WhatsappNotificationService.send_message(
          to: @professional.phone,
          message: message,
          confirmation_url: confirmation_url
        )

        respond_to do |format|
          format.html { redirect_to appointments_path, notice: "Solicitação de agendamento enviada para o profissional." }
        end
      else
        @professionals = User.professionals
        render :new, status: :unprocessable_entity
      end
    else
      @professionals = User.professionals
      render :new, status: :unprocessable_entity
    end
  end

  def confirm
    @appointment = Appointment.find(params[:id])
    @appointment.update(status: "confirmed")

    # Notifica o cliente que o agendamento foi confirmado
    WhatsappNotificationService.send_message(
      to: @appointment.client.phone,
      message: "Olá #{@appointment.client.name}, seu agendamento com #{@appointment.user.name} para #{@appointment.date.strftime('%d/%m/%Y às %H:%M')} foi confirmado!"
    )

    redirect_to appointment_path(@appointment), notice: "Agendamento confirmado com sucesso!"
  end

  def show
  end

  def edit
    @professionals = User.where(admin: false)
  end

  def update
    @appointment = Appointment.find(params[:id])
    @professional = @appointment.user

    if @appointment.update(appointment_params)
      if current_user.admin?
        redirect_to user_appointments_path(@professional), notice: "Agendamento atualizado com sucesso."
      else
        redirect_to user_appointments_path(current_user), notice: "Agendamento atualizado com sucesso."
      end
    else
      @professionals = User.where(admin: false)
      render :edit
    end
  end

  def destroy
    @appointment = Appointment.find(params[:id])
    @appointment.destroy

    respond_to do |format|
      format.html { redirect_to user_appointments_path(@appointment.user), notice: "Agendamento excluído com sucesso." }
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@appointment) }
    end
  end

  def by_phone
    @client = Client.find_by(phone: params[:phone])
    if @client
      @appointments = @client.appointments
    else
      @appointments = []
    end
    render :index
  end

  def available_dates_and_times
    @professional = User.find(params[:user_id])
    @date = params[:date]

    # Obtém todas as datas disponíveis
    @available_dates = @professional.disponibilidades
                                  .pluck(:data)
                                  .uniq
                                  .sort

    @available_times = if @date.present?
      # Obtém todos os horários disponíveis para a data selecionada
      available_times = @professional.disponibilidades
                                   .where(data: @date)
                                   .pluck(:horario)
                                   .map { |t| t.strftime("%H:%M") }
                                   .uniq
                                   .sort

      # Obtém os horários já agendados para a data
      booked_times = @professional.appointments_as_professional
                                 .where("DATE(date) = ?", @date)
                                 .pluck(:date)
                                 .map { |dt| dt.strftime("%H:%M") }

      # Remove os horários já agendados da lista de disponíveis
      available_times - booked_times
    else
      []
    end

    render json: {
      dates: @available_dates,
      times: @available_times
    }
  end

  private

  def set_professional
    if params[:user_id].present?
      @professional = User.find(params[:user_id])
    else
      @professional = User.where(admin: false).first
    end
  end

  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:date, :time, :user_id, :client_name, :client_phone)
  end

  def find_or_create_client
    Client.find_or_create_by(phone: params[:appointment][:client_phone]) do |client|
      client.name = params[:appointment][:client_name]
    end
  end
end
