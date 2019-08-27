# frozen_string_literal: true

Rails.application.routes.draw do
  default_url_options host: 'test.host'
  devise_for :accounts, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  devise_scope :account do
    root to: 'devise/sessions#new'
    get '/accounts/sign_out' => 'devise/sessions#destroy'
  end
  resources :accounts, except: %i[new create index]
  resources :companies do
    resources :employees, except: :index
    resources :working_days
    resources :events
    get :employee_events
    get :calendar
    resources :holidays do
      collection do
        post :calendarific_import
      end
    end
    resources :rules
  end
end
