# frozen_string_literal: true

class EmployeeEventsService
  attr_reader :employee

  def initialize(employee)
    @employee = employee
  end

  def events(from, to)
    events_dates = Event.employee_events(from, to).where(employee_id: employee.id)
    events_dates.group_by(&:start_period)
  end
end
