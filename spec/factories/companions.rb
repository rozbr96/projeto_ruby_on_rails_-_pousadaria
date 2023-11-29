FactoryBot.define do
  factory :companion do
    document_type { ['RG', 'CPF'].sample }
    name { Faker::Name.name }

    after :build do |companion|
      next unless companion.document_number.nil?

      companion.document_number = Faker::IDNumber.brazilian_citizen_number if companion.document_type == 'CPF'
      companion.document_number = Faker::IDNumber.brazilian_id if companion.document_type == 'RG'
    end
  end
end
