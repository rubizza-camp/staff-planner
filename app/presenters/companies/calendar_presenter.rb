# frozen_string_literal: true

module Companies
  class CalendarPresenter
    attr_reader :company, :name, :id, :days, :working_days

    # rubocop:disable Metrics/AbcSize
    def initialize(params)
      @company = Company.find(params[:company_id])
      @days = if params[:start_period].present? && params[:end_period].present?
                (params[:start_period].to_date)..params[:end_period].to_date.to_a
              else
                ((Date.today)..(Date.today + 30)).to_a
              end
      @working_days = company.working_days.pluck(:day_of_week)
    end
    # rubocop:enable Metrics/AbcSize

    def employees
      @employees ||= company.employees.includes(:account)
    end

    def employees_events(_employee)
      events = Event.employee_events(@days.first, @days.last)
      events_ranges = []
      events.each do |event|
        range = (event.start_period.to_date)..(event.end_period.to_date)
        date_range = range.uniq(&:day)
        date_range.each do |day|
          events_ranges.push(day)
        end
      end
      events_ranges.uniq
    end

    def days_status(employee)
      days.each_with_object({}) do |day, working_month|
        working_month[day] = working_days.include?(day.strftime('%w').to_i) ? 'work' : 'holiday'
        working_month[day] = 'event' if employees_events(employee).include?(day.to_date)
      end
    end
  end
end
