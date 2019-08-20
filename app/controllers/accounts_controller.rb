# frozen_string_literal: true

class AccountsController < ApplicationController
  before_action :set_account, except: :index
  before_action :find_account_companies, only: :show
  load_and_authorize_resource

  def index
    @accounts = Account.all
  end

  def show
    @account_events = @account.events
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

  def find_account_companies
    @companies = @account.companies
  end
end
