# frozen_string_literal: true

class EventsController < ApplicationController
  before_action :set_event, only: %i[show edit update destroy edit]
  before_action :set_account, only: %i[show new update destroy index]
  before_action :company_rules, only: %i[create new]

  def index
    @events = Event.all
  end

  def show; end

  def new
    @event = Event.new
  end

  def edit; end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to company_events_path, notice: 'Event was successfully created.'
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
      redirect_to company_events_path, notice: 'Event was successfully destroyed.'
    else
      render :edit
    end
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def company_rules
    set_account
    company_id = @account.employees.pluck(:company_id).join('')
    company = Company.find(company_id)
    @rules = company.rules
  end

  def set_account
    @account = current_account
  end

  def event_params
    params[:employee_id] = current_account.employees.pluck(:id).join('')
    params.permit(:start_period, :end_period, :reason, :employee_id, :company_id, :rule_id)
  end
end
