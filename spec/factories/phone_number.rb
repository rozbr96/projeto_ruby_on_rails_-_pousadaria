
FactoryBot.define do
  factory :phone_number do
    city_code { Faker::PhoneNumber.area_code }
    number { Faker::Number.between from: 900_000_000, to: 999_999_999 }
    name { Faker::Name.first_name }
  end
end
