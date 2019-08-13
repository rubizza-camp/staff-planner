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
      @employees ||= company.employees.includes(:account)
    end

    def days_status
      days.inject({}) { | (day, status), working_month| working_month[day] = working_days.include?(day.strftime('%w').to_i) ? 'work' : 'holiday' }
    end
  end
end
