# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    name { 'Simon' }
    surname { 'Simonee' }
    email { 'simoneeesssse@gmail.com' }
    password { '123456' }
  end
end
