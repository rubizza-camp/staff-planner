# frozen_string_literal: true

class AllowanceService
  attr_reader :current_account, :rule, :event_range, :events

  def initialize(current_account, event_params)
    @current_account = current_account
    @rule = Rule.find(event_params[:rule_id])
    @event_range = (event_params[:start_period].to_date)..(event_params[:end_period].to_date)
    @events = Event.range(period.first, period.last).where(rule: rule, employee: current_account)
  end

  def allow?
    remaining_days = rule.allowance_days - used_days
    if event_range.first.strftime('%Y-%m').eql?(event_range.last.strftime('%Y-%m'))
      remaining_days - event_range.count >= 0
    else
      false
    end
  end

  private

  def period
    case rule.period
    when 'month'
      @period = Date.today.at_beginning_of_month..Date.today.at_end_of_month
    when 'year'
      @period = Date.today.at_beginning_of_year..Date.today.at_end_of_year
    end
  end

  def used_days
    events.inject(0) do |sum, event|
      date_range = (event[:start_period].to_date)..(event[:end_period].to_date)
      sum + date_range.sum { |day| period.include?(day) ? 1 : 0 }
    end
  end
end
