# frozen_string_literal: true

FactoryBot.define do
  factory :working_day do
    company
    day_of_week { rand(7) }
  end
end
