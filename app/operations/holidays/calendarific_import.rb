# frozen_string_literal: true

module Holidays
  class CalendarificImport
    def call(params)
      holidays = create_holidays(parsed_country(params), params)
      if holidays.present?
        Result::Success.new(holidays)
      else
        Result::Failure.new(holidays)
      end
    end

    def parsed_country(params)
      params = {
        api_key: Rails.application.secrets.token_calendarific,
        country: params[:country],
        year: params[:year]
      }.to_query

      uri = URI("https://calendarific.com/api/v2/holidays?&#{params}")

      JSON.parse(Net::HTTP.get(uri))
    end

    def create_holidays(parsed_country, params)
      company = params[:company_id]

      parsed_country.dig('response', 'holidays').each do |holiday|
        Holiday.create(
          name: holiday['name'],
          date: holiday.dig('date', 'iso'),
          company_id: company
        )
      end
    end
  end
end
