# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[edit update destroy show]
  before_action :rules, only: %i[new edit create update]
  before_action :authenticate_account!
  load_and_authorize_resource :company
  load_and_authorize_resource through: :company, except: :create

  def index
    @employee = Employee.find(params[:employee_id])
    @presenter = Events::IndexPresenter.new(@employee, current_ability, params)
    @employees = @company.employees.where.not(account: nil).includes(:account)
  end

  def show; end

  def new
    @event = @rules.first&.events&.build(employee: employee)
  end

  def edit; end

  def create
    result = Events::Create.new(current_account).call(create_event_params)
    return redirect_to calendar_path if result.success?

    @event = result.value
    render :new
  end

  def update
    result = Events::Update.new(current_account).call(@event, update_event_params)
    return redirect_to calendar_path if result.success?

    render :edit
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
    params.require(:event).permit(:reason, :employee_id, :rule_id)
  end

  def create_event_params
    event_params.merge(Events::DeterminePeriod.new(params.require(:event)).call)
                .merge(company_id: @company.id)
  end

  def update_event_params
    event_params.merge(Events::DeterminePeriod.new(params.require(:event)).call)
  end
end
