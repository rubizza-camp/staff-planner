# frozen_string_literal: true

module Events
  class Update
    attr_reader :current_account

    def initialize(current_account)
      @current_account = current_account
    end

    def call(event, params)
      event.attributes = update_params(params)
      event.valid?
      event.to_pending
      event.accept if event.rule.auto_confirm
      validate_result = Events::ValidatePeriod.new(event, params).call
      return Result::Failure.new(event) unless validate_result.success?

      result(event.rule, validate_result.value)
    end

    def result(rule, event)
      return Result::Failure.new(event) unless Events::AllowanceService.can_create?(rule, event)

      return Result::Failure.new(event) unless event.save

      EventMailer.send_email(event, current_account).deliver_later
      Result::Success.new(event)
    end

    private

    def update_params(params)
      return {} unless params[:event]

      params.require(:event).permit(
        :start_period, :end_period, :reason, :rule_id
      )
    end
  end
end
