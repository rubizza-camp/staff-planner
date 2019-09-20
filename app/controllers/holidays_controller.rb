# frozen_string_literal: true

class HolidaysController < ApplicationController
  before_action :set_holiday, only: %i[show edit update destroy]
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company

  def index
    @holidays = @company.holidays.order(:name).page(params[:page])
  end

  def show; end

  def new
    @holiday = @company.holidays.build
  end

  def edit; end

  def create
    @holiday = @company.holidays.build(holiday_params)

    if @holiday.save
      redirect_to holidays_path, notice: 'Holiday was successfully created.'
    else
      render :new
    end
  end

  def update
    if @holiday.update(holiday_params)
      redirect_to holidays_path, notice: 'Holiday was successfully updated.'
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
    redirect_to holidays_path
  end

  def calendarific_import
    result = Holidays::CalendarificImport.new.call(params, @company.id)

    if result.success?
      flash[:notice] = 'Holidays was successfully created.'
    else
      flash[:error] = 'Holidays was not created.'
    end
    redirect_to holidays_path
  end

  private

  def set_holiday
    @holiday = @company.holidays.find_by!(id: params[:id])
  end

  def holiday_params
    params.require(:holiday).permit(:name, :date)
  end
end
