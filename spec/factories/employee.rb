# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    start_day { '2014-09-09' }
    position { 'Boss' }
    is_enabled { true }
    company_id { '0' }
    account_id { '0' }
  end
end
