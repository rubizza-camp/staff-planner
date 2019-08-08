Rails.application.routes.draw do
  resources :rules
  devise_for :accounts
  devise_scope :account do
    root to: "devise/sessions#new"
  end

  resources :accounts, except: [:new, :create]

  resources :companies do
    resources :employees
    resources :working_days
  end
end
