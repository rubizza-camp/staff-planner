# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]
  helper_method :resource_name, :resource, :devise_mapping

  def index
    @accounts = Account.all
  end

  def show; end

  def edit; end

  def update
    if @account.update(account_params)
      redirect_to account_path,
                  notice: 'Account was successfully updated.'
    else
      redirect_to edit_account_path(@account),
                  notice: 'Please check parameters'
    end
  end

  def destroy
    if @account.destroy
      redirect_to accounts_path,
                  notice: 'You have successfully cancelled your account.'
    else
      redirect_to :back
    end
  end

  private

  def account_params
    permitted = params.require(:account)
                      .permit(:name,
                              :surname,
                              :email,
                              :password,
                              :date_of_birth)
    attributes = permitted.to_h || {}
    attributes.symbolize_keys
  end

  def set_account
    @account = Account.find(params[:id])
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
