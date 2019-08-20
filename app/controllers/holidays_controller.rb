# frozen_string_literal: true

class HolidaysController < ApplicationController
  before_action :set_company
  before_action :set_holiday, only: %i[show edit update destroy]
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company

  def index
    @holidays = @company.holidays.all
  end

  def show; end

  def new
    @holiday = @company.holidays.build
  end

  def edit; end

  def create
    @holiday = @company.holidays.build(holiday_params)

    if @holiday.save
      redirect_to company_holidays_url, notice: 'Holiday was successfully created.'
    else
      render :new
    end
  end

  def update
    if @holiday.update(holiday_params)
      redirect_to company_holidays_url, notice: 'Holiday was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @holiday.destroy
      flash[:notice] = 'You have successfully delete holiday.'
    else
      flash[:error] = "Holiday can't be deleted"
    end
    redirect_to company_holidays_url
  end

  private

  def set_company
    @company = Company.find(params[:company_id])
  end

  def set_holiday
    @holiday = @company.holidays.find_by!(id: params[:id])
  end

  def holiday_params
    params.require(:holiday).permit(:name, :date)
  end
end
