# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: 'test.host'

  devise_for :accounts, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :account do
    root to: 'devise/sessions#new'
    get '/accounts/sign_out' => 'devise/sessions#destroy'
  end

  get :calendar, to: 'companies#calendar'

  resources :accounts, except: %i[new create index]
  resources :companies, except: :index do
    post :switch
  end
  resources :employees, except: :index do
    resources :events, only: :index
  end
  resources :events, except: :index do
    patch :accept
    patch :decline
  end
  resources :holidays do
    collection do
      post :calendarific_import
    end
  end
  resources :rules
  resources :working_days
end
