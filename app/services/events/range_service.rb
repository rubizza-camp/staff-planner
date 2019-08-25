# frozen_string_literal: true

module Events
  class RangeService
    attr_reader :employee

    def initialize(employee)
      @employee = employee
    end

    def events(from, to)
      Event.range(from, to).where(employee_id: employee.id)
           .group_by(&:start_period)
    end
  end
end
