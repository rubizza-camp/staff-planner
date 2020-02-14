# frozen_string_literal: true

module Companies
  class CalendarPresenter
    DEFAULT_PERIOD_DAYS = 30

    attr_reader :company, :name, :id, :days, :working_days, :events, :holidays, :current_account_id

    # rubocop: disable Metrics/AbcSize
    def initialize(company, current_account_id, params)
      @company = company
      @days = get_period(params)
      @working_days = company.working_days.pluck(:day_of_week)
      @events = Event.range(days.first, days.last).includes(:rule).group_by(&:employee_id)
      @holidays = Holiday.where(date: days.first..days.last)
      @current_account_id = current_account_id
    end
    # rubocop: enable Metrics/AbcSize

    def employees
      @employees ||= company
                     .employees
                     .where.not(account: nil)
                     .includes(:account)
                     .order(['accounts.id=? DESC, accounts.name', current_account_id])
    end

    def employee_events(employee)
      events[employee.id]
        .map { |event| (event.start_period.to_date)..(event.end_period.to_date) }
        .flat_map(&:to_a)
    end

    # rubocop: disable Metrics/AbcSize

    def days_status(employee)
      days.each_with_object({}) do |day, working_month|
        working_month[day] = working_days.include?(day.strftime('%w').to_i) ? { state: 'work' } : { state: 'holiday' }
        working_month[day] = { state: 'state_holiday' } if holidays.include?(day)
        working_month[day] = { state: 'fullday_event', rule: define_rule(employee, day) } if
          events[employee.id].present? && employee_events(employee).include?(day.to_date)
        next unless working_month[day][:state] == 'fullday_event'

        half_event(day, working_month)
      end
    end

    # rubocop: disable Metrics/MethodLength
    def half_event(day, working_month)
      events.each do |_employee, employee_events|
        employee_events.each do |event|
          if event.end_period.to_date.eql?(day) && event.end_period.hour == Event::HALF_DAY
            working_month[day] = { state: 'first_half_of_day', rule: event.rule }
          elsif event.start_period.hour == Event::HALF_DAY &&
                event.end_period.hour == Event::END_DAY &&
                (event.end_period..event.start_period).include?(day)
            working_month[day] = { state: 'second_half_of_day', rule: event.rule }
          end
        end
      end
    end
    # rubocop: enable Metrics/MethodLength
    # rubocop: enable Metrics/AbcSize

    private

    def define_rule(employee, day)
      selected_events = events[employee.id].select { |event| event_in_day?(event, day) }
      selected_events.map(&:rule)
    end

    def event_in_day?(event, day)
      event.start_period.to_date <= day && event.end_period.to_date >= day
    end

    def get_period(params)
      start_period = (params[:start_period].presence || Date.today).to_date
      end_period = (params[:end_period].presence || (start_period + DEFAULT_PERIOD_DAYS)).to_date

      start_period..end_period
    end
  end
end
