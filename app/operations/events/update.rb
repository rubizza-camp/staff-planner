# frozen_string_literal: true

module Events
  class Update
    attr_reader :params, :company, :current_account, :event

    def initialize(event, current_account, params, company)
      @params = params
      @company = company
      @current_account = current_account
      @event = event
    end

    # rubocop: disable Metrics/AbcSize
    def call(role)
      event.attributes = update_params
      event.valid?
      rule = event.rule
      if rule.auto_confirm
        event.accept
      elsif role != 'owner' && !event.pending?
        event.to_pending
      end
      approved_event = Events::ValidatePeriod.new(event, params).call
      result(rule, approved_event.value)
    end
    # rubocop: enable Metrics/AbcSize

    def result(rule, event)
      return Result::Failure.new(event) unless Events::AllowanceService.can_create?(rule, event)

      return Result::Failure.new(event) unless event.save

      EventMailer.send_email(company, event, current_account).deliver_later
      Result::Success.new(event)
    end

    private

    def update_params
      return {} unless params[:event]

      params.require(:event).permit(
        :start_period, :end_period, :reason, :employee_id, :company_id, :rule_id
      )
    end
  end
end
