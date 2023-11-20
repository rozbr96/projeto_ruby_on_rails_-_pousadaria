
FactoryBot.define do
  factory :booking do
    start_date { Faker::Date.in_date_period year: 2020 }
    guests_number { 1 }
    status { 0 }
    code { Faker::Alphanumeric.alphanumeric(number: 8).upcase }

    after :build do |object|
      object.end_date ||= Faker::Date.between from: object.start_date.tomorrow,
        to: object.start_date.next_year
    end
  end
end
