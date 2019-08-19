# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show edit update destroy calendar employee_events]
  before_action :authenticate_account!
  load_and_authorize_resource

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
    result = Companies::Create.new.call(company_params, current_account.id)
    @company = result.value
    if result.success?
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
    day = event_params[:day].to_date if event_params[:day].present?
    @employee_events = EmployeeEventsService.new(event_params, day).events
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find(params[:id] || params[:company_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:name)
  end

  def event_params
    params.permit(:day, :employee, :start_period, :end_period)
  end
end
