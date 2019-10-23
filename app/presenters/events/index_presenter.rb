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
      @events ||= @employee.events.accessible_by(current_ability).range(from, to)
    end

    def employees
      employee.company.employees
              .where.not(account: nil)
              .includes(:account)
              .accessible_by(current_ability, :show)
    end

    private

    def determine_from_to(params)
      return from_to_from_day(params[:day].to_date) if params[:day].present?

      if params[:start_period].present? || params[:end_period].present?
        return from_to_from_period(params[:start_period], params[:end_period])
      end

      from_to_default
    end

    def from_to_from_day(day)
      [day.beginning_of_day, day.end_of_day]
    end

    def from_to_from_period(start_period, end_period)
      start_period = - Float::INFINITY unless start_period.present?
      end_period = if end_period.present?
                     end_period.to_date.end_of_day
                   else
                     Float::INFINITY
                   end
      [start_period, end_period]
    end

    def from_to_default
      [Date.today.beginning_of_day, (Date.today + 1.month).end_of_day]
    end
  end
end
