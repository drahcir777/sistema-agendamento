class Users::SessionsController < Devise::SessionsController
  def create
    super do |resource|
      if resource.admin?
        redirect_to admin_path and return
      else
        redirect_to user_appointments_path(resource) and return
      end
    end
  end
end
