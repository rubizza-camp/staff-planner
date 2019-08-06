# frozen_string_literal: true

class EmployeesController < ApplicationController
  before_action :set_employee, :set_company, only: %i[show edit update destroy]

  def index
    @employees = Employee.where("company_id=?",params[:company_id])
  end

  def show; end

  def new; end

  def edit; end

  def create
    @employee = Employee.new(employee_params)
      if @employee.save
      else
        render :new 
      end
  end

  def update
      if @employee.update(employee_params)
        redirect_to @employee, notice: 'Employee was successfully updated.' 
      else
        render :edit 
      end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee.destroy
      redirect_to employees_url, notice: 'Employee was successfully destroyed.' 
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  def set_company
    @company = Company.find(params[:company_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.fetch(:employee, {})
  end
end
