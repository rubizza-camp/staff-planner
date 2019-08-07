Rails.application.routes.draw do
  resources :working_days
  resources :rules
  resources :companies
  devise_for :accounts
  devise_scope :account do
    root to: "devise/sessions#new"
  end

  resources :accounts, except: [:new, :create]
end
