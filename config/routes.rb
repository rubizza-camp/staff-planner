Rails.application.routes.draw do
  resources :companies
  devise_for :accounts
  devise_scope :account do
    root to: "devise/sessions#new"
  end
end
