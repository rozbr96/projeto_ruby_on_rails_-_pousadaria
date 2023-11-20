
FactoryBot.define do
  factory :inn_room do
    name { Faker::Name.unique.name }
    description { Faker::Lorem.paragraph }
    dimension { Faker::Number.between from: 20, to: 200 }
    price { Faker::Number.between from: 50_00, to: 1000_00 }
    maximum_number_of_guests { Faker::Number.between from: 1, to: 10 }
    number_of_bathrooms { Faker::Number.between from: 0, to: 2 }
    number_of_wardrobes { Faker::Number.between from: 0, to: 2 }
    has_balcony { Faker::Boolean.boolean }
    has_tv { Faker::Boolean.boolean }
    has_air_conditioning { Faker::Boolean.boolean }
    has_vault { Faker::Boolean.boolean }
    is_accessible_for_people_with_disabilities { Faker::Boolean.boolean }
    enabled { Faker::Boolean.boolean true_ratio: 0.75 }
  end
end
