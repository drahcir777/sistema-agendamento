class ServicesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_service, only: [ :show, :edit, :update, :destroy ]

  def index
    @services = Service.all
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(service_params)
    if @service.save
      redirect_to services_path, notice: "Serviço criado com sucesso."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @service.update(service_params)
      redirect_to services_path, notice: "Serviço atualizado com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @service.destroy
    redirect_to services_path, notice: "Serviço excluído com sucesso."
  end

  private

  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :description, :duration_hours, :duration_minutes)
  end

  def check_admin
    redirect_to(root_path, alert: "Você não tem permissão para acessar esta página.") unless current_user.admin?
  end
end
