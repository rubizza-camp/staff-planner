# frozen_string_literal: true

module Events
  class Create
    attr_reader :current_account

    def initialize(current_account)
      @current_account = current_account
    end

    # rubocop: disable Metrics/AbcSize
    def call(employee, params)
      event = employee.events.build(create_params(params))
      event.company = employee.company
      event.valid?
      return Result::Failure.new(event) unless create_params(params)[:rule_id]

      event.accept if event.rule.auto_confirm
      validate_result = Events::ValidatePeriod.new(event, params).call
      return Result::Failure.new(event) unless validate_result.success?

      result(event.rule, validate_result.value)
    end
    # rubocop: enable Metrics/AbcSize

    def result(rule, event)
      return Result::Failure.new(event) unless Events::AllowanceService.can_create?(rule, event)

      return Result::Failure.new(event) unless event.save

      EventMailer.send_email(event, current_account).deliver_later
      Result::Success.new(event)
    end

    private

    def create_params(params)
      return {} unless params[:event]

      params.require(:event).permit(
        :start_period, :end_period, :reason, :employee_id, :rule_id
      )
    end
  end
end
