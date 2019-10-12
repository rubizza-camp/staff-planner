# frozen_string_literal: true

module Employees
  class FillInAccount
    def call(account)
      Employee.where(email: account.email).each do |employee|
        employee.account = account
        employee.save
      end
    end
  end
end
