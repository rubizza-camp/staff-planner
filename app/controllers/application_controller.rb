# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_account!
  before_action :current_company
  before_action :account_employee, unless: :devise_controller?
  before_action :account_companies, unless: :devise_controller?

  def account_companies
    @account_companies = current_account.companies if current_account
  end

  def account_employee
    @account_employee = current_account.employees.find_by(company_id: @current_company_id) if current_account
  end

  def current_company
    @current_company_id = session[:current_company_id]
    return if @current_company_id
    return unless current_account

    @current_company_id = current_account.employees.first&.company_id
    session[:current_company_id] = @current_company_id
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name surname])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email])
  end

  def after_sign_up_path_for(resource)
    account_path(id: resource.id)
  end

  def after_sign_in_path_for(resource)
    account_path(id: resource.id)
  end

  def after_sign_out_path_for(_resourse)
    new_account_session_path
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_account)
  end

  rescue_from CanCan::AccessDenied do |_exception|
    flash[:error] = 'Access denied.'
    redirect_to root_path
  end
end
