# frozen_string_literal: true

module Events
  class AllowanceService
    # rubocop: disable Metrics/AbcSize
    def self.can_create?(event)
      event_range = (event.start_period.to_date)..(event.end_period.to_date)
      remaining_days = RemainingDaysService.new.call(event.employee, event.rule)
      if event_range.first.strftime('%Y-%m').eql?(event_range.last.strftime('%Y-%m'))
        remaining_days - event_range.count >= 0
      else
        false
      end
    end
    # rubocop: enable Metrics/AbcSize
  end
end
