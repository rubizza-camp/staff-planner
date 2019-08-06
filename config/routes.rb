Rails.application.routes.draw do
  resources :rules
  resources :companies
  devise_for :accounts
  devise_scope :account do
    root to: "devise/sessions#new"
  end
end
