# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: 'test.host'
  devise_for :accounts, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :account do
    root to: 'devise/sessions#new'
    get '/accounts/sign_out' => 'devise/sessions#destroy'
  end
  resources :accounts, except: %i[new create index]
  resources :companies, except: :index do
    resources :employees, except: :index do
      resources :events, only: :index
    end
    resources :working_days
    resources :events, except: :index do
      patch :accept
      patch :decline
    end
    get :calendar
    post :switch
    resources :holidays do
      collection do
        post :calendarific_import
      end
    end
    resources :rules
  end
end
