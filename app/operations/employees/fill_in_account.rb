# frozen_string_literal: true

module Employees
  class FillInAccount
    def call(account)
      Employee.where(email: account.email).update_all(account_id: account.id)
    end
  end
end
