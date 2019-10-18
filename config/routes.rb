# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'companies#calendar', as: :calendar
  default_url_options host: 'test.host'

  devise_for :accounts, controllers: { omniauth_callbacks: 'omniauth_callbacks', registrations: 'registrations' }

  devise_scope :account do
    root to: 'devise/sessions#new'
    get '/accounts/sign_out' => 'devise/sessions#destroy'
  end

  resources :accounts, except: %i[new create index]
  resources :companies, except: :index do
    collection do
      get :invites
      post :switch
    end
  end
  resources :employees, except: :index do
    resources :events, only: :index
  end
  resources :events, except: %i[destroy index] do
    patch :accept
    patch :decline
  end
  resources :holidays do
    collection do
      post :calendarific_import
    end
  end
  resources :rules
  resource :slack_notification, except: %i[show destroy]
  resources :working_days
end
