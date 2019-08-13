# frozen_string_literal: true

class EmployeesController < ApplicationController
  before_action :set_params
  before_action :set_employee, only: %i[show edit update destroy]
  before_action :authenticate_account!
  load_and_authorize_resource

  def show; end

  def new
    @employee = @company.employees.build
  end

  def edit; end

  def create
    employee = @company.employees.build(employee_params)
    if employee.save
      redirect_to company_path(@company.id)
    else
      render :new
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to company_employee_path, notice: 'Employee was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @employee.destroy
      flash[:notice] = 'You have successfully cancelled your employee.'
    else
      flash[:error] = "Employee account wasn't cancelled."
    end
    redirect_to company_path(@employee.company_id)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_params
    @company = Company.find(params[:company_id])
    @employees = @company.employees
    @accounts = @company.accounts
  end

  def set_employee
    @employee = @company.employees.find_by!(id: params[:id])
  end

  def employee_params
    if params[:email]
      params[:account_id] = Account.find_by(email: params[:email]).id
      params.permit(:position,
                    :start_day,
                    :account_id,
                    :role)
    else
      params.permit(:position,
                    :start_day,
                    :role)
    end
  end
end
