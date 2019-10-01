# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    start_period { Date.today.to_datetime.change(hour: Event::START_DAY) }
    end_period { Date.today.to_datetime.change(hour: Event::END_DAY) }
    state { 'pending' }
    reason { 'MyString' }
    employee
    company
    rule
  end
end
