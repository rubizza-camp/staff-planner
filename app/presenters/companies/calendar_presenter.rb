# frozen_string_literal: true

module Companies
  class CalendarPresenter
    attr_reader :company

    def initialize(params)
      @company = Company.find(params[:company_id])
    end

    def days
      ((Date.today)..(Date.today + 30)).to_a
    end

    def employees
      @employees ||= company.employees.includes(:account)
    end

    def company_name
      company.name
    end

    def working_days
      working_days = company.working_days.pluck(:day_of_week)
      working_days.map do |day|
        working_days << (day + 1)
      end
      working_days
    end

    def working_day?(day)
      working_days.include?(day.strftime('%u').to_i)
    end
  end
end
