FactoryBot.define do
  factory :holiday do
    name { "Gazprom" }
    date { Date.today + 1 }
    company
  end
end
