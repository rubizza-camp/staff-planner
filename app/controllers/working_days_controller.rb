class WorkingDaysController < ApplicationController
  before_action :set_working_day, only: [:show, :edit, :update, :destroy]

  # GET /working_days
  def index
    @working_days = WorkingDay.all
  end

  # GET /working_days/1
  def show
  end

  # GET /working_days/new
  def new
    @working_day = WorkingDay.new
  end

  # GET /working_days/1/edit
  def edit
  end

  # POST /working_days
  def create
    @working_day = WorkingDay.new(working_day_params)

    if @working_day.save
      redirect_to @working_day, notice: 'Working day was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /working_days/1
  def update
    if @working_day.update(working_day_params)
      redirect_to @working_day, notice: 'Working day was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /working_days/1
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
    params.require(:working_day).permit(:company_id, :day_of_week)
  end
end
