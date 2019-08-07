# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    start_day { '2014-09-09' }
    position { 'Boss' }
    is_enabled { true }
    company_id { Company.create!(name: 'Company').id }
    account_id { Account.create!(name: 'Ars', surname: 'Arsen', email: 'Arsen@gmail.com', password: '123456').id }
  end
end
