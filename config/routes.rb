Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  get "users/:id/appointments", to: "users#appointments", as: "user_appointments"

  resources :services

  resources :appointments do
    collection do
      get "available_dates_and_times"
    end
  end

  resources :users do
    resources :appointments, only: [ :new, :create ], controller: "appointments"
  end

  get "appointments/phone", to: "appointments#by_phone", as: "appointments_by_phone"
  resources :disponibilidades

  get "/admin", to: "admin#index"
  resources :clients

  root to: "home#index"
end
