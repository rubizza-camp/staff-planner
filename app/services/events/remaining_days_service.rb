# frozen_string_literal: true

module Events
  class RemainingDaysService
    def call(employee, rule)
      period = get_period(rule)
      events = employee.events
                       .range(period.first, period.last)
                       .where(rule: rule)
                       .where.not(state: :declined)
      "#{rule.allowance_days - used_days(events, period)} / #{rule.period}"
    end

    private

    def get_period(rule)
      case rule.period
      when 'week'
        Date.today.at_beginning_of_week..Date.today.at_end_of_week
      when 'month'
        Date.today.at_beginning_of_month..Date.today.at_end_of_month
      when 'year'
        Date.today.at_beginning_of_year..Date.today.at_end_of_year
      end
    end

    def used_days(events, period)
      events.inject(0) do |sum, event|
        date_range = (
          event[:start_period].to_date)..(event[:end_period].to_date)
        sum + date_range.sum { |day| period.include?(day) ? 1 : 0 }
      end
    end
  end
end
