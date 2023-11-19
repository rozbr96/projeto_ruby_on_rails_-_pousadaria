
FactoryBot.define do
  factory :booking do
    start_date { Faker::Date.in_date_period year: 2020, month: 1 }
    end_date { Faker::Date.in_date_period year: 2020, month: 10 }
    guests_number { 1 }
    status { 0 }
    code { Faker::Alphanumeric.alphanumeric(number: 8).upcase }
  end
end
