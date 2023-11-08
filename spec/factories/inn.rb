
FactoryBot.define do
  factory :inn do
    name { Faker::Company.unique.name }
    registration_number { Faker::Company.brazilian_company_number }
    description { Faker::Lorem.paragraph }
    pets_are_allowed { Faker::Boolean.boolean }
    usage_policies {  Faker::Lorem.paragraph }
    email { Faker::Internet.email }
    enabled { Faker::Boolean.boolean true_ratio: 0.8 }
    check_in { Faker::Time.between from: DateTime.now - 1, to: DateTime.now }
    check_out { Faker::Time.between from: DateTime.now - 1, to: DateTime.now }

    after :build do |object, values|
      object.corporate_name = "#{values.name} LTDA"
    end
  end
end
