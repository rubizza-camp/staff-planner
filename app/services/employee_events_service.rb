# frozen_string_literal: true

class EmployeeEventsService
  attr_reader :employee, :events_dates

  def initialize(employee, params, day)
    @employee = employee
    @events_dates = if params[:start_period].present?
                      employee.events
                              .where('start_period >= ? AND end_period <= ?',
                                     params[:start_period], params[:end_period])
                    else
                      employee.events.where('start_period <= ? AND end_period >= ?', day, day)
                    end
  end

  def events
    events_dates.each_with_object({}) do |event, events|
      events[event.start_period] = [event]
    end
  end
end
