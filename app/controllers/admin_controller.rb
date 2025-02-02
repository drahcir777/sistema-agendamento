class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  def index
    @professionals = User.where(admin: false)
  end


  private

  def check_admin
    redirect_to(root_path, alert: "Você não tem permissão para acessar esta página.") unless current_user.admin?
  end
end
