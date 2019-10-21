# frozen_string_literal: true

module Events
  class AllowanceService
    def self.can_create?(event)
      event_range = receive_event_range(event)
      remaining_days = Events::RemainingDaysService.new
                                                   .call(event.employee, event.rule)
      if event_range.first.strftime('%Y-%m').eql?(
        event_range.last.strftime('%Y-%m')
      )
        remaining_days - event_range.count >= 0
      else
        false
      end
    end

    def self.receive_event_range(event)
      (event.start_period.to_date)..(event.end_period.to_date)
    end
  end
end
