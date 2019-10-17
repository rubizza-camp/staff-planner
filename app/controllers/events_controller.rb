# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[edit update destroy show]
  before_action :rules, only: %i[new edit]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company, except: :create

  def index
    @employee = Employee.find(params[:employee_id])
    @presenter = Events::IndexPresenter.new(@employee, current_ability, params)
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
      @event = result.value
      rules
      render :new
    end
  end

  def update
    result = Events::Update.new(@event, current_account, params, @company).call(@account_employee.role)
    if result.success?
      redirect_to calendar_path
    else
      rules
      render :edit
    end
  end

  def accept
    event = Event.find(params[:event_id])
    flash[:error] = 'Accept failed' unless event.accept!
    redirect_back(fallback_location: calendar_path)
  end

  def decline
    event = Event.find(params[:event_id])
    flash[:error] = 'Decline failed' unless event.decline!
    redirect_back(fallback_location: calendar_path)
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def rules
    @rules = @company.rules
  end

  def employee
    return @account_employee if @account_employee.role != 'owner'

    employee_id = params.dig(:event, :employee_id)
    return @company.employees.find(employee_id) if employee_id

    @account_employee
  end

  def event_params
    params.require(:event).permit(:employee_id)
  end
end
