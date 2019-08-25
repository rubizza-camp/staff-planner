# frozen_string_literal: true

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.filter_sensitive_data('<SECRET>') do
    Rails.application.credentials.vcr[:token_calendarific]
  end
end
