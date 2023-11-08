
FactoryBot.define do
  factory :innkeeper do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password }
  end
end
