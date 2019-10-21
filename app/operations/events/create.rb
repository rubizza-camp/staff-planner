# frozen_string_literal: true

module Events
  class Create
    attr_reader :current_account

    def initialize(current_account)
      @current_account = current_account
    end

    def call(employee, params)
      event = employee.events.build(params)
      event.company = employee.company
      return Result::Failure.new(event) unless event.valid?

      event.accept if event.rule.auto_confirm
      result(event.rule, validate_result.value)
    end

    def result(rule, event)
      return Result::Failure.new(event) unless Events::AllowanceService.can_create?(rule, event)

      return Result::Failure.new(event) unless event.save

      EventMailer.send_email(event, current_account).deliver_later
      Result::Success.new(event)
    end
  end
end
