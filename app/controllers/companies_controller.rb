# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show edit update destroy calendar]

  # GET /companies
  def index
    @companies = Company.includes(:employees)
  end

  # GET /companies/1
  def show; end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit; end

  # POST /companies
  def create
    @company = Company.new(company_params)
    if @company.save
      redirect_to @company, notice: 'Company was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update(company_params)
      redirect_to @company, notice: 'Company was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /companies/1
  def destroy
    if @company.destroy
      flash[:notice] = 'You have successfully delete company.'
    else
      flash[:error] = "Company can't be deleted"
    end
    redirect_to companies_url
  end

  def calendar
    @calendar = Companies::CalendarPresenter.new(params)
  end

  def employee_events
    @day = event_params[:day].to_date
    employee = Employee.find(event_params[:employee])
    @employee_events = EmployeeEventsService.new(employee).events
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = if params[:id].present?
                 Company.find(params[:id])
               else
                 Company.find(params[:company_id])
               end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:name)
  end

  def event_params
    params.permit(:day, :employee)
  end
end
