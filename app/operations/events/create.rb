# frozen_string_literal: true

module Events
  class Create
    def call(event_params, event, current_account)
      if AllowanceService.new(current_account, event_params).allow?
        event.save
        Result::Success.new(event)
      else
        Result::Failure.new(event)
      end
    end
  end
end
