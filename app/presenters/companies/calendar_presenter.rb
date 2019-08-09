# frozen_string_literal: true

module Companies
  class CalendarPresenter
    def days
      ((Date.today)..(Date.today + 30)).to_a
    end

    def employees(company)
      @employees ||= company.employees.includes(:account)
    end
  end
end
