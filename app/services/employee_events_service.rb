# frozen_string_literal: true

class EmployeeEventsService
  attr_reader :events_dates, :employee

  def initialize(employee, params)
    @employee = employee
    @events_dates = if params[:start_period].present?
                      Event.employee_events(params[:start_period].to_date, params[:end_period].to_date).to_a
                    else
                      employee.events.pluck(:start_period, :end_period)
                    end
  end

  # rubocop: disable Metrics/AbcSize
  # rubocop: disable Metrics/MethodLength
  # rubocop: disable Lint/ShadowingOuterLocalVariable
  def day_event(day)
    events = {}
    events_dates.each do |date|
      date_range = (date[0].to_date)..(date[1].to_date)
      date_range.each do |day|
        if events[day].present?
          events[day] << employee.events.where(start_period: date[0]).to_a
          events[day] = events[day].flatten
        else
          events[day] = employee.events.where(start_period: date[0]).to_a
        end
      end
    end
    events.select { |k, _v| k == day }
  end
  # rubocop: enable Metrics/AbcSize
  # rubocop: enable Metrics/MethodLength
  # rubocop: enable Lint/ShadowingOuterLocalVariable

  def period_event
    events = {}
    events_dates.each do |event|
      events[event.start_period] = [event]
    end
    events
  end
end
