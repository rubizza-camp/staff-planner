# frozen_string_literal: true

module Companies
  class CalendarPresenter
    attr_reader :company, :name, :id

    def initialize(params)
      @company = Company.find(params[:company_id])
      @name = company.name
      @id = company.id
    end

    def days
      ((Date.today)..(Date.today + 30)).to_a
    end

    def employees
      @employees ||= company.employees.includes(:account)
    end

    def prepare_working_days
      @working_days = []
      company.working_days.pluck(:day_of_week).map do |day|
        if day.zero?
          @working_days.push(7)
        else
          @working_days.push(day)
        end
      end
    end

    def working_day?(day)
      prepare_working_days
      @working_days.include?(day.strftime('%u').to_i)
    end
  end
end
