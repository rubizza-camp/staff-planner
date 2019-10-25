# frozen_string_literal: true

class EmployeesController < ApplicationController
  before_action :set_params
  before_action :set_employee, only: %i[show edit update destroy]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company

  def show
    params[:employee_id] = params[:id]
    @events_presenter = Events::IndexPresenter.new(@company, current_ability, params)
  end

  def new
    @employee = @company.employees.build
  end

  def edit; end

  def create
    result = Employees::Create.new.call(employee_params, @company)
    if result.success?
      redirect_to company_path(@company.id)
    else
      @employee = result.value
      render :new
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to company_path(@company.id)
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
    @employees = @company.employees
    @accounts = @company.accounts
  end

  def set_employee
    @employee = @company.employees.find_by!(id: params[:id])
  end

  def employee_params
    params.require(:employee).permit(:position, :start_day, :role, :email)
  end
end
