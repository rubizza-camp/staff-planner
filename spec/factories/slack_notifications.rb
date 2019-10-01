# frozen_string_literal: true

FactoryBot.define do
  factory :slack_notification do
    company
    token { 'anything' }
    is_enabled { true }
  end
end
