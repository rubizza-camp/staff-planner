# frozen_string_literal: true

module Events
  class IndexPresenter
    attr_reader :current_ability, :from, :to, :company, :params
    def initialize(company, current_ability, params)
      @company = company
      @params = params
      @current_ability = current_ability
      @from, @to = from_to_from_period(params[:start_period], params[:end_period])
    end

    # rubocop: disable Metrics/AbcSize
    def events
      @events = company.events
                       .accessible_by(current_ability)
                       .range(from, to)
                       .includes(:employee)
                       .order(updated_at: :desc)
      @events = @events.where(employee_id: params[:employee_id]) if params[:employee_id].present?
      @events
    end
    # rubocop: enable Metrics/AbcSize

    def employees
      company.employees
             .where.not(account: nil)
             .includes(:account)
             .accessible_by(current_ability, :show)
             .order('accounts.surname, accounts.name')
    end

    private

    def from_to_from_period(start_period, end_period)
      start_period = - Float::INFINITY unless start_period.present?
      end_period = if end_period.present?
                     end_period.to_date.end_of_day
                   else
                     Float::INFINITY
                   end
      [start_period, end_period]
    end
  end
end
