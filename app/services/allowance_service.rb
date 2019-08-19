# frozen_string_literal: true

class AllowanceService
  attr_reader :current_account, :rule, :new_event, :events

  def initialize(current_account, event_params)
    @current_account = current_account
    @rule = Rule.find(event_params[:rule_id])
    @new_event = (event_params[:start_period].to_date)..(event_params[:end_period].to_date)
    @events = Event.employee_events(period.first, period.last).where(rule_id: rule.id)
  end

  def allow?
    remaining_days = rule.allowance_days - used_days
    remaining_days - new_event.count >= 0
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
    used_days = 0
    events.each do |event|
      date_range = (event[:start_period].to_date)..(event[:end_period].to_date)
      date_range.each { |day| used_days += 1 if period.include?(day) }
    end
    used_days
  end
end
