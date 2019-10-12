# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    association :company
    association :account
    start_day { '2014-09-09' }
    position { 'Boss' }
    is_enabled { true }
    role { 'owner' }
    email { 'any_email@any_domain' }
  end
end
