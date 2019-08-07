# frozen_string_literal: true

class EmployeesController < ApplicationController
  before_action :set_employee, only: %i[show edit update destroy]
  before_action :set_company

  def index
    @employees = Employee.where(company_id: @company.id)
  end

  def show; end

  def new; end

  def edit; end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to company_employees_path
    else
      flash[:error] = 'Please try again. Your input information not valid'
      render :new
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to company_employee_path, notice: 'Employee was successfully updated.'
    else
      flash[:error] = "Employee account wasn't updated"
      render :edit
    end
  end

  def destroy
    if @employee.destroy
      flash[:notice] = 'You have successfully cancelled your employee.'
    else
      flash[:error] = "Employee account wasn't cancelled."
    end
    redirect_to company_employees_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

  def employee_params
    params.permit(:position,
                  :is_enabled,
                  :start_day,
                  :company_id)
  end
end
