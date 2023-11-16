FactoryBot.define do
  factory :guest do
    name { Faker::Name.name }
    citizen_number { Faker::IDNumber.brazilian_citizen_number }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
  end
end
