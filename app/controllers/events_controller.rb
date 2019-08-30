# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[edit update destroy show]
  before_action :company_rules, only: %i[create new]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company

  def index
    employee = Employee.find(params[:employee_id])
    from, to = determine_from_to(params)
    @events = EmployeeEventsService.new(employee).events(from, to).accessible_by(current_ability)
  end

  def show; end

  def new
    @event = Event.new(event_params)
  end

  def edit; end

  def create
    result = Events::Create.new.call(@company, event_params, current_account)
    if result.success?
      redirect_to company_calendar_path
    else
      render :new
    end
  end

  def update
    if @event.update(event_params)
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

  def accept
    event = Event.find(params[:event_id])
    flash[:error] = 'Accept failed' unless event.accept!
    redirect_to company_calendar_path
  end

  def decline
    event = Event.find(params[:event_id])
    flash[:error] = 'Decline failed' unless event.decline!
    redirect_to company_calendar_path
  end

  private

  def determine_from_to(params)
    from = params[:day]&.to_date&.beginning_of_day || params[:start_period]
    to = params[:day]&.to_date&.end_of_day || params[:end_period]
    [from, to]
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def company_rules
    @company = Company.find(params[:company_id])
    @rules = @company.rules
  end

  def event_params
    return unless params[:event]

    params.require(:event).permit(:start_period, :end_period, :reason, :employee_id, :company_id, :rule_id)
  end
end
