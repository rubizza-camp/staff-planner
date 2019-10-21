# frozen_string_literal: true

module Events
  class Update
    attr_reader :current_account

    def initialize(current_account)
      @current_account = current_account
    end

    def call(event, params)
      event.attributes = params
      return Result::Failure.new(event) unless event.valid?

      return Result::Failure.new(event) unless Events::AllowanceService.can_create?(event)

      event.to_pending
      event.accept if event.rule.auto_confirm
      return Result::Failure.new(event) unless event.save

      EventMailer.send_email(event, current_account).deliver_later
      Result::Success.new(event)
    end
  end
end
