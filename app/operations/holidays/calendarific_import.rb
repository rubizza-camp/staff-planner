# frozen_string_literal: true

module Holidays
  class CalendarificImport
    def call(params)
      create_holidays(parsed_country(params), params)
    end

    def parsed_country(params)
      country = params[:country]
      year = params[:year]
      token = Rails.application.secrets.token_calendarific

      uri = URI("https://calendarific.com/api/v2/holidays?&api_key=#{token}&country=#{country}&year=#{year}")
      JSON.parse(Net::HTTP.get(uri))
    end

    def create_holidays(parsed_country, params)
      company = params[:company_id]

      parsed_country.dig('response', 'holidays').each do |holiday|
        new_holiday = Holiday.new(name: holiday['name'], date: holiday.dig('date', 'iso'), company_id: company)
        new_holiday.save
      end
    end
  end
end
