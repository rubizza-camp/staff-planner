# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[edit update destroy show]
  before_action :rules, only: %i[create new]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company, except: :create

  def index
    @employee = Employee.find(params[:employee_id])
    from, to = determine_from_to(params)
    @employee_events = @employee.events.range(from, to).accessible_by(current_ability)
  end

  def show; end

  def new
    @event = @rules.first&.events&.build(employee: employee)
  end

  def edit; end

  def create
    result = Events::Create.new(current_account, params, @company, employee).call
    if result.success?
      redirect_to calendar_path
    else
      render :new
    end
  end

  def update
    result = Events::Update.new.call(@event, params)
    if result.success?
      redirect_to events_path, notice: 'Event was successfully updated.'
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
    redirect_to events_path
  end

  def accept
    event = Event.find(params[:event_id])
    flash[:error] = 'Accept failed' unless event.accept!
    redirect_to calendar_path
  end

  def decline
    event = Event.find(params[:event_id])
    flash[:error] = 'Decline failed' unless event.decline!
    redirect_to calendar_path
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

  def rules
    @rules = @company.rules
  end

  def employee
    byebug
    return @account_employee if @account_employee.role != 'owner'

    employee_id = params[:employee_id]
    employee_id ||= params[:event][:employee_id] if params[:event]
    return @company.employees.find(employee_id) if employee_id

    @account_employee
  end
end
