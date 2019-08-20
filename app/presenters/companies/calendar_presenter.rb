# frozen_string_literal: true

module Companies
  class CalendarPresenter
    attr_reader :company, :name, :id, :days, :working_days, :events, :holidays

    # rubocop: disable Metrics/AbcSize
    def initialize(params)
      @company = Company.find(params[:company_id])
      @days = if params[:start_period].present? && params[:end_period].present?
                (params[:start_period].to_date)..(params[:end_period].to_date)
              else
                (Date.today)..(Date.today + 30)
              end
      @working_days = company.working_days.pluck(:day_of_week)
      @events = Event.range(@days.first, @days.last).group_by(&:employee_id)
      @holidays = Holiday.all.where('date BETWEEN ? AND ?', days.first, days.last)
    end
    # rubocop: enable Metrics/AbcSize

    def employees
      @employees ||= company.employees.includes(:account)
    end

    def employee_events(employee)
      events[employee.id]
        .map { |event| (event.start_period.to_date)..(event.end_period.to_date) }
        .flat_map(&:to_a)
    end

    # rubocop: disable Metrics/AbcSize
    def days_status(employee)
      holidays
      days.each_with_object({}) do |day, working_month|
        working_month[day] = working_days.include?(day.strftime('%w').to_i) ? 'work' : 'holiday'
        working_month[day] = 'event' if events[employee.id].present? && employee_events(employee).include?(day.to_date)
        working_month[day] = 'state_holiday' if holidays.include?(day)
      end
    end
    # rubocop: enable Metrics/AbcSize
  end
end
