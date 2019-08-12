# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account
  before_action :find_account_company, only: %i[show index]

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

  def find_account_company
    @companies = {}
    @account.companies.each do |company|
      @companies[company.id] = company.name
    end
  end
end
