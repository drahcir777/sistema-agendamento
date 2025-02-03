class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy, :appointments ]


  def create
    @user = User.new(user_params)
    if @user.save
      create_appointments_for_services(@user)
      redirect_to admin_path, notice: "Profissional criado com sucesso."
    else
      render :new
    end
  end
  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_path, notice: "Usuário atualizado com sucesso."
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_path, notice: "Usuário excluído com sucesso."
  end

  def appointments
    @appointments = @user.appointments_as_professional
  end

  private

  def create_appointments_for_services(user)
    user.services.each do |service|
      # Lógica para criar horários disponíveis na agenda do profissional
      # com base na duração do serviço
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
  end
end
