# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
  	association :company
  	association :account
    start_day { '2014-09-09' }
    position { 'Boss' }
    is_enabled { true }
    company_id { company.id }
    account_id { account.id }
  end
end
