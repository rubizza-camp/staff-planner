# frozen_string_literal: true

module Events
  class ValidatePeriod
    attr_reader :params, :event

    def initialize(params)
      @params = params
    end

    def call
      valid_period? ? Result::Success.new(start_period: st) : Result::Failure.new(event)
    end

    def start_period
      hour = params[:first_period].eql?('Morning') ? Event::START_DAY : Event::HALF_DAY
      params[:start_day].to_datetime.change(hour: hour)
    end

    def end_period
      hour = params[:second_period].eql?('Afternoon') ? Event::HALF_DAY : Event::END_DAY
      params[:end_day].to_datetime.change(hour: hour)
    end

    private

    def valid_period?
      start_period.present? && end_period.present?
    end
  end
end
