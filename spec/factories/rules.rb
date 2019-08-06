FactoryBot.define do
  factory :rule do
    name { "holiday" }
    company_id { Company.create(name: 'MyCompany').id }
    alowance_days { 25 }
    period { "year" }
    is_enabled { true }
  end
end
