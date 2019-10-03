# frozen_string_literal: true

module Events
  class IndexPresenter
    attr_reader :current_ability, :from, :to, :employee
    def initialize(employee, current_ability, params)
      @employee = employee
      @current_ability = current_ability
      @from, @to = determine_from_to(params)
    end

    def events
      @events ||= @employee.events.range(from, to).accessible_by(current_ability)
    end

    private

    def determine_from_to(params)
      return from_to_from_day(params[:day].to_date) if params[:day].present?

      if params[:start_period].present? && params[:end_period].present?
        return from_to_from_period(params[:start_period], params[:end_period])
      end

      from_to_default
    end

    def from_to_from_day(day)
      [day.beginning_of_day, day.end_of_day]
    end

    def from_to_from_period(_start_period, _end_period)
      [params[:start_period], params[:end_period]]
    end

    def from_to_default
      [Date.today, Date.today + 1.month]
    end
  end
end
