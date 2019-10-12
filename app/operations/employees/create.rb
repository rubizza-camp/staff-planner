# frozen_string_literal: true

module Employees
  class Create
    def call(employee_params, company)
      employee = company.employees.build(employee_params)
      employee.account = Account.find_by(email: employee_params[:email])
      employee.save!
      InviteUserMailer.send_email(employee.email, company).deliver_later unless employee.account
      Result::Success.new(employee)
    rescue ActiveRecord::RecordInvalid => e
      Result::Failure.new(employee, e.message)
    end
  end
end
