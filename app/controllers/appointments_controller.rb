class AppointmentsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :new, :create, :show, :edit, :update, :destroy, :by_phone ]
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
    @professionals = User.where(admin: false)
  end

  def create
    @professional = User.find(appointment_params[:user_id])
    @appointment = @professional.appointments_as_professional.new(appointment_params)
    @appointment.client = find_or_create_client

    if @appointment.save
      respond_to do |format|
        if user_signed_in?
          if current_user.admin?
            format.html { redirect_to user_appointments_path(@professional), notice: "Agendamento criado com sucesso." }
          else
            format.html { redirect_to user_appointments_path(current_user), notice: "Agendamento criado com sucesso." }
            format.turbo_stream { redirect_to user_appointments_path(current_user), notice: "Agendamento criado com sucesso." }
          end
        else
          format.html { redirect_to appointments_path, notice: "Agendamento criado com sucesso." }
        end
      end
    else
      render :new
    end
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

  private

  def find_professional
    @professional = User.find(params[:user_id])
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
    params.require(:appointment).permit(:date, :user_id, :client_name, :client_phone)
  end

  def find_or_create_client
    Client.find_or_create_by(phone: params[:appointment][:client_phone]) do |client|
      client.name = params[:appointment][:client_name]
    end
  end
end
