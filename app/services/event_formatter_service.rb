# frozen_string_literal: true

class FormatterService
  attr_reader :params, :event

  def initialize(event, params)
    @params = params[:event]
    @event = event
  end

  # rubocop: disable Metrics/AbcSize
  def call
    event.start_period = if params[:first_period].eql?('Morning')
                           params[:start_day].to_datetime.change(hour: 9)
                         else
                           params[:start_day].to_datetime.change(hour: 15)
                         end

    event.end_period = if params[:second_period].eql?('Afternoon')
                         params[:end_day].to_datetime.middle_of_day.change(hour: 15)
                       else
                         params[:end_day].to_datetime.end_of_day.change(hour: 21)
                       end
  end
  # rubocop: enable Metrics/AbcSize
end
