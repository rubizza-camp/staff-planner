# frozen_string_literal: true

module Holidays
  class CalendarificImport
    def call(params)
      holidays = create_holidays(params)
      if holidays.present?
        Result::Success.new(holidays)
      else
        Result::Failure.new(holidays)
      end
    end

    private

    def create_holidays(params)
      list_holidays = parsed_country(params)
      return if !list_holidays || list_holidays['response'].empty?

      list_holidays.dig('response', 'holidays').each do |holiday|
        Holiday.create(
          name: holiday['name'],
          date: holiday.dig('date', 'iso'),
          company_id: params[:company_id]
        )
      end
    end

    def parsed_country(params)
      url_params = {
        api_key: Rails.application.secrets.token_calendarific,
        country: params[:country],
        year: params[:year]
      }

      uri = URI("https://calendarific.com/api/v2/holidays?#{url_params.to_query}")

      JSON.parse(Net::HTTP.get(uri))
    end
  end
end
