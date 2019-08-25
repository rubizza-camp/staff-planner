# frozen_string_literal: true

module Events
  class Update
    def call(event, params)
      result = Events::ValidatePeriod.new(event, params).call
      if result.success? && result.value.update(update_params(params))
        Result::Success.new(event)
      else
        Result::Failure.new(event)
      end
    end

    private

    def update_params(params)
      params.require(:event).permit(:reason)
    end
  end
end
