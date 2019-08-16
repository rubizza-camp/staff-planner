# frozen_string_literal: true

class EmployeeEventsService
  attr_reader :events_dates, :employee

  def initialize(employee)
    @employee = employee
    @events_dates = employee.events.pluck(:start_period, :end_period)
  end

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def events
    events = {}
    events_dates.each do |date|
      date_range = ((date[0].to_date)..(date[1].to_date))
      date_range.each do |day|
        if events[day].present?
          events[day] << employee.events.where(start_period: date[0]).to_a
          events[day] = events[day].flatten
        else
          events[day] = employee.events.where(start_period: date[0]).to_a
        end
      end
    end
    events
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/AbcSize
end
