class Users::RegistrationsController < Devise::RegistrationsController
  skip_before_action :require_no_authentication, only: [ :new, :create ]

  def new
    super
  end

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        redirect_to admin_path # Redireciona para o painel de admin
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        redirect_to admin_path # Redireciona para o painel de admin
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end
