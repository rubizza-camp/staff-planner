FactoryBot.define do
  factory :event do
    start_period { "2019-08-12 23:41:47" }
    end_period { "2019-08-12 23:41:47" }
    reason { "MyString" }
    employee { nil }
    company { nil }
    rule { nil }
  end
end
