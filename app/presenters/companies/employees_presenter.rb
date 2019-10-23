# frozen_string_literal: true

module Companies
  class EmployeesPresenter
    def call(company, current_ability)
      company.employees.where.not(account: nil)
             .includes(:account)
             .accessible_by(current_ability, :show)
    end
  end
end
