# frozen_string_literal: true

module Events
  class Create
    def call(event_params, company, current_account)
      if AllowanceService.new(current_account, event_params).allow?
        event = company.events.build(event_params)
        event.employee = Employee.find_by(account: current_account, company: company)
        Result::Success.new(event)
      else
        Result::Failure.new(event)
      end
    end
  end
end
