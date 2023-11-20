
FactoryBot.define do
  factory :custom_price do
    start_date { Faker::Date.in_date_period year: 2020 }
    price { Faker::Number.between from: 50_00, to: 1000_00 }

    after :build do |object|
      object.end_date ||= Faker::Date.between from: object.start_date.tomorrow,
        to: object.start_date.next_month
    end
  end
end
