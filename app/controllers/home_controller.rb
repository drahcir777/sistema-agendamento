class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    if user_signed_in?
      if current_user.admin?
        redirect_to admin_path
      else
        redirect_to user_appointments_path(current_user)
      end
    else
      redirect_to appointments_path
    end
  end
end
