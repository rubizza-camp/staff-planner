# frozen_string_literal: true

class EmployeeEventsService
  attr_reader :events_dates, :employee

  def initialize(employee, params)
    @employee = employee
    if params[:start_period].present?
      @days = ((params[:start_period].to_date)..(params[:end_period].to_date)).to_a
      @events_dates = employee.events
                              .where('GREATEST( start_period, ? ) < LEAST( end_period, ? )', @days.first, @days.last)
                              .pluck(:start_period, :end_period)
    else
      @events_dates = employee.events.pluck(:start_period, :end_period)
    end
  end

  # rubocop: disable Metrics/AbcSize
  # rubocop: disable Metrics/MethodLength
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
  # rubocop: enable Metrics/AbcSize
  # rubocop: enable Metrics/MethodLength

  def day_event(day)
    events.select { |k, _v| k == day }
  end
end
