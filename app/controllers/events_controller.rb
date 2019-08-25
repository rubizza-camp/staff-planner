# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[edit update destroy show]
  before_action :company_rules, only: %i[create new]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company

  def index
    @events = Event.all
  end

  def show; end

  def new
    @event = Event.new(event_params)
  end

  def edit; end

  def create
    result = Events::Create.new(current_account, params, @company).call
    if result.success?
      redirect_to company_events_path
    else
      render :new
    end
  end

  def update
    result = Events::Update.new.call(@event, params)
    if result.success?
      redirect_to company_events_path, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @event.destroy
      flash[:notice] = 'You have successfully cancelled your employee.'
    else
      flash[:error] = "Employee account wasn't cancelled."
    end
    redirect_to company_events_path
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def company_rules
    @company = Company.find(params[:company_id])
    @rules = @company.rules
  end

  def event_params
    return unless params[:event]

    params.require(:event).permit(:start_period)
  end
end
