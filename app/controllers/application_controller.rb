# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_account!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name surname])
  end

  def after_sign_up_path_for(resource)
    account_path(id: resource.id)
  end

  def after_sign_in_path_for(resource)
    account_path(id: resource.id)
  end

  def after_sign_out_path_for(resourse)
    new_account_session_path
  end

  protected

  def configure_permitted_params
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit( :password, :email) }
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit( :name, :surname, :password, :password_confirmation, :email) }
  end
end
