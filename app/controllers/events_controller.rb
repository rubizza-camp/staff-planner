# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[edit update destroy show]
  before_action :company_rules, only: %i[create new]
  before_action :authenticate_account!
  load_and_authorize_resource :company

  def index
    @events = Event.all
  end

  def show; end

  def new
    @event = Event.new(event_params)
  end

  def edit; end

  # rubocop: disable Metrics/AbcSize
  def create
    @event = @company.events.build(event_params)
    @event.employee = Employee.find_by(account: current_account, company: @company)
    limit = AllowanceService.new(current_account, event_params)
    if limit.allow?
      @event.save
      redirect_to company_events_path
    else
      redirect_to new_company_event_path,
                  alert: "You can't have enough days. Allowance days: #{limit.rule.allowance_days}"
    end
  end
  # rubocop: enable Metrics/AbcSize

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

    params.require(:event).permit(:start_period, :end_period, :reason, :employee_id, :company_id, :rule_id)
  end
end
