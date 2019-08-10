# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]

  def index
    @accounts = Account.all
  end

  def show
    @companies = @account.company
    @company_names = @account.company.collect(&:name).pluck
    @company_ids = @account.company.collect(&:id).pluck
  end

  def edit; end

  def update
    if @account.update(account_params)
      redirect_to account_path,
                  notice: 'Account was successfully updated.'
    else
      render :edit,
             notice: 'Please check parameters'
    end
  end

  def destroy
    if @account.destroy
      flash[:notice] = 'You have successfully cancelled your account.'
    else
      flash[:error] = "Account can't be deleted"
    end
    redirect_to accounts_path
  end

  private

  def account_params
    params.require(:account)
          .permit(:name,
                  :surname,
                  :email,
                  :password,
                  :date_of_birth)
  end

  def set_account
    @account = Account.find(params[:id])
  end
end
