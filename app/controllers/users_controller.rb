class UsersController < ApplicationController
  before_action :set_user, only: [ :edit, :update, :destroy, :appointments ]

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
