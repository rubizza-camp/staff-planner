# frozen_string_literal: true

class WorkingDaysController < ApplicationController
  before_action :set_working_day, only: %i[show edit update destroy]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company

  def index
    @working_days = @company.working_days.all.map { |working_day| WorkingDayDecorator.new(working_day) }
  end

  def show; end

  def new
    @working_day = @company.working_days.build
  end

  def edit; end

  def create
    @working_day = @company.working_days.build(working_day_params)

    if @working_day.save
      redirect_to working_days_path, notice: 'Working day was successfully created.'
    else
      render :new
    end
  end

  def update
    if @working_day.update(working_day_params)
      redirect_to working_days_path, notice: 'Working day was successfully updated.'
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
    redirect_to working_days_path
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_working_day
    working_day = @company.working_days.find_by!(id: params[:id])
    @working_day = WorkingDayDecorator.new(working_day)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def working_day_params
    params.require(:working_day).permit(:day_of_week)
  end
end
