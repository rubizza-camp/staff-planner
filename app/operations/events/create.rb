# frozen_string_literal: true

module Events
  class Create
    def call(company, event_params, current_account)
      event = company.events.build(event_params)
      event.employee = Employee.find_by(account: current_account, company: company)
      if AllowanceService.allow?(event.rule_id, event)
        event.save
        EventMailer.send_email(company, event, current_account).deliver_now
        Result::Success.new(event)
      else
        Result::Failure.new(event)
      end
    end
  end
end
