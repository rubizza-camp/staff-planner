FactoryBot.define do
  factory :working_day do
    company_id { Company.create(name: 'MyCompany').id }
    day_of_week { rand(7) }
  end
end
