class RemainingDaysService
  def call(employee_id, rule_id)
    rule = Rule.find(rule_id)
    period = get_period(rule)
    events = Event.range(period.first, period.last).where(rule: rule, employee_id: employee_id)
    rule.allowance_days - used_days(events, period)
  end

  private

  def get_period(rule)
    case rule.period
    when 'month'
      Date.today.at_beginning_of_month..Date.today.at_end_of_month
    when 'year'
      Date.today.at_beginning_of_year..Date.today.at_end_of_year
    end
  end

  def used_days(events, period)
    events.inject(0) do |sum, event|
      date_range = (event[:start_period].to_date)..(event[:end_period].to_date)
      sum + date_range.sum { |day| period.include?(day) ? 1 : 0 }
    end
  end
end
