# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_account!
  before_action :account_companies, unless: :devise_controller?

  # rubocop: disable Metrics/AbcSize
  def account_companies
    account_company_ids = current_account.employees.pluck(:company_id)
    @account_companies = account_company_ids.map { |id| Company.find(id.to_i) }
                                            .map { |company| [company.name, company.id] }
    @account_companies.delete_if do |company|
      company == [session[:company_name], session[:company_id].to_i]
    end.unshift([session[:company_name], session[:company_id]])
  end

  def select_company
    session[:company_id] = if params[:selected_company].present?
                             params[:selected_company]
                           else
                             current_account.employees.pluck(:company_id)[0]
                           end
    session[:company_name] = Company.find(session[:company_id].to_i).name
    redirect_to company_calendar_path(session[:company_id])
  end
  # rubocop: enable Metrics/AbcSize

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
