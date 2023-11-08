
FactoryBot.define do
  factory :custom_price do
    start_date { Faker::Date.in_data_period year: 2020, month: 1 }
    end_date { Faker::Date.in_data_period year: 2020, month: 19 }
    price { Faker::Number.between from: 50, to: 1000 }
  end
end
