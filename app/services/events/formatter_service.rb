# frozen_string_literal: true

module Events
  class FormatterService
    attr_reader :params, :event

    def initialize(event, params)
      @params = params[:event] ||= params
      @event = event
    end

    def call
      start_period
      end_period
    end

    def start_period
      hour = if params[:first_period].eql?('Morning')
               Event::START_DAY
             else
               Event::HALF_DAY
             end
      event.start_period = params[:start_day].to_datetime.change(hour: hour)
    end

    def end_period
      hour = if params[:second_period].eql?('Afternoon')
               Event::HALF_DAY
             else
               Event::END_DAY
             end
      event.end_period = params[:end_day].to_datetime.change(hour: hour)
    end
  end
end
