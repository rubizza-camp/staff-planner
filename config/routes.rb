Rails.application.routes.draw do
  devise_for :accounts
  devise_scope :account do
    root to: "devise/sessions#new"
  end
  resources :accounts, except: [:new, :create]
  resources :companies do
    resources :employees
    get :calendar
    resources :working_days
    resources :holidays
  end
  resources :rules
end
