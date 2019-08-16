# frozen_string_literal: true

module Companies
  class CalendarPresenter
    attr_reader :company, :name, :id, :days, :working_days

    def initialize(params)
      @company = Company.find(params[:company_id])
      @days = ((Date.today)..(Date.today + 30)).to_a
      @working_days = company.working_days.pluck(:day_of_week)
    end

    def employees
      employees ||= company.employees.includes(:account)
    end

    def employees_events(employee)
      events = employee.events.pluck(:start_period, :end_period)
      events_ranges = []
      events.each do |event|
        range = ((event[0].to_date)..(event[1].to_date))
        date_range = range.uniq(&:day)
        date_range.each do |day|
          events_ranges.push(day)
        end
      end
      Set.new(events_ranges).to_a
    end

    def days_status(employee)
      days.each_with_object({}) do |day, working_month|
        working_month[day] = working_days.include?(day.strftime('%w').to_i) ? 'work' : 'holiday'
        working_month[day] = 'event' if employees_events(employee).include?(day.to_date)
      end
    end
  end
end
