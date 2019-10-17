# frozen_string_literal: true

module Events
  class Update
    attr_reader :params, :company, :current_account, :event

    def initialize(event, current_account, params, company)
      @params = params
      @company = company
      @current_account = current_account
      @event = event
      @event.attributes = update_params
    end

    # rubocop: disable Metrics/AbcSize
    def call(role)
      event.valid?
      rule = Rule.find(update_params[:rule_id])
      if rule.auto_confirm
        event.accept
      elsif role != 'owner' && !event.pending?
        event.to_pending
        need_send_email = true
      end
      approved_event = Events::ValidatePeriod.new(event, params).call
      result(rule, approved_event.value, need_send_email)
    end
    # rubocop: enable Metrics/AbcSize

    def result(rule, event, need_send_email)
      if Events::AllowanceService.can_create?(rule, event)
        event.save
        EventMailer.send_email(company, event, current_account).deliver_later if need_send_email
        Result::Success.new(event)
      else
        Result::Failure.new(event)
      end
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
