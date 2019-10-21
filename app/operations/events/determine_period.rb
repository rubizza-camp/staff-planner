# frozen_string_literal: true

module Events
  class DeterminePeriod
    attr_reader :params, :event

    def initialize(params)
      @params = params
    end

    def call
      { start_period: start_period, end_period: end_period }
    end

    def start_period
      hour = params[:first_period].eql?('Morning') ? Event::START_DAY : Event::HALF_DAY
      params[:start_day].to_datetime.change(hour: hour)
    end

    def end_period
      hour = params[:second_period].eql?('Afternoon') ? Event::HALF_DAY : Event::END_DAY
      params[:end_day].to_datetime.change(hour: hour)
    end
  end
end
