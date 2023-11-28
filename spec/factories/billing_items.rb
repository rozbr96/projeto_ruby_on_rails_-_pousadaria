FactoryBot.define do
  factory :billing_item do
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Number.between from: 1_00, to: 100_00 }
    amount { Faker::Number.between from: 1, to: 10 }
  end
end
