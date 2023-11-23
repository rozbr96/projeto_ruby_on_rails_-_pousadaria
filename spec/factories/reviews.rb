FactoryBot.define do
  factory :review do
    score { Faker::Number.between from: 0, to: 5 }
    guest_commentary { Faker::Lorem.paragraph }
    innkeeper_reply { Faker::Lorem.paragraph }
  end
end
