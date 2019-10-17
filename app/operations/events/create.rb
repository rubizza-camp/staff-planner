# frozen_string_literal: true

module Events
  class Create
    attr_reader :params, :company, :current_account, :employee

    def initialize(current_account, params, company, employee)
      @params = params
      @company = company
      @current_account = current_account
      @employee = employee
    end

    # rubocop: disable Metrics/AbcSize
    def call
      event = company.events.build(create_params)
      event.employee = employee
      event.valid?
      return Result::Failure.new(event) unless create_params[:rule_id]

      rule = Rule.find(create_params[:rule_id])
      event.accept if rule.auto_confirm
      approved_event = Events::ValidatePeriod.new(event, params).call
      result(rule, approved_event.value)
    end
    # rubocop: enable Metrics/AbcSize

    def result(rule, event)
      if Events::AllowanceService.can_create?(rule, event)
        event.save
        EventMailer.send_email(company, event, current_account).deliver_later
        Result::Success.new(event)
      else
        Result::Failure.new(event)
      end
    end

    private

    def create_params
      return {} unless params[:event]

      params.require(:event).permit(
        :start_period, :end_period, :reason, :employee_id, :company_id, :rule_id
      )
    end
  end
end
