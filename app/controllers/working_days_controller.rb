# frozen_string_literal: true

class WorkingDaysController < ApplicationController
  before_action :set_working_day, only: %i[show edit update destroy]
  before_action :set_company

  def index
    @working_days = WorkingDay.where(company_id: @company.id)
  end

  def show; end

  def new; end

  def edit
  end

  def create
    @working_day = WorkingDay.new(working_day_params)

    if @working_day.save
      redirect_to company_working_days_path, notice: 'Working day was successfully created.'
    else
      render :new
    end
  end

  def update
    if @working_day.update(working_day_params)
      redirect_to @working_day, notice: 'Working day was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @working_day.destroy
      flash[:notice] = 'You have successfully delete workng day.'
    else
      flash[:error] = "Working day can't be deleted"
    end
    redirect_to working_days_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_working_day
    @working_day = WorkingDay.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def working_day_params
    result = params.permit(:company_id, :day_of_week)
  end

  def employee_params
    params.permit(:position,
                  :is_enabled,
                  :start_day,
                  :company_id)
  end

  def set_company
    @company = Company.find(params[:company_id])
  end
end
