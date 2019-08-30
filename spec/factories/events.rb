# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    start_period { '2019-08-12 23:41:47' }
    end_period { '2019-08-12 23:41:47' }
    state { 'pending' }
    reason { 'MyString' }
    employee
    company
    rule
  end
end
