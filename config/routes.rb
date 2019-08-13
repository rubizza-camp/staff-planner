Rails.application.routes.draw do
  default_url_options :host => "test.host"
  devise_for :accounts
  devise_scope :account do
    root to: "devise/sessions#new"
    get '/accounts/sign_out' => 'devise/sessions#destroy' 
  end
  resources :accounts, except: [:new, :create]
  resources :companies do
    resources :employees, except: :index
    get :calendar
    resources :working_days
  end
  resources :rules
end
