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

    def working_day?(day)
      company.working_days.ids.include?(day.strftime('%u').to_i)
    end
  end
end
