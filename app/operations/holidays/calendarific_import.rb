# frozen_string_literal: true

module Holidays
  class CalendarificImport
    def call(params, company_id)
      holidays = create_holidays(params, company_id)
      if holidays.present?
        Result::Success.new(holidays)
      else
        Result::Failure.new(holidays)
      end
    end

    private

    def create_holidays(params, company_id)
      list_holidays = parsed_country(params)
      return if !list_holidays || !list_holidays['response'].is_a?(Hash)
      return unless list_holidays.dig('response', 'holidays').is_a?(Array)

      list_holidays = list_holidays.dig('response', 'holidays').map do |holiday|
        { name: holiday['name'],
          date: holiday.dig('date', 'iso'),
          company_id: company_id }
      end

      Holiday.create(list_holidays)
    end

    def parsed_country(params)
      url_params = {
        api_key: Rails.application.credentials.vcr[:token_calendarific],
        country: params[:country],
        year: params[:year]
      }

      uri = URI("https://calendarific.com/api/v2/holidays?#{url_params.to_query}")

      JSON.parse(Net::HTTP.get(uri))
    end
  end
end
