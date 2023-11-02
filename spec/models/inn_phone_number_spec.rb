require 'rails_helper'

RSpec.describe InnPhoneNumber, type: :model do
  describe '#valid?' do
    context 'uniqueness' do
      it 'should fail if same inn and phone_number are used twice' do
        innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'
        inn = Inn.create!(
          name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
          registration_number: '11338082000103', description: 'Pousada universal...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: false, innkeeper: innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        phone_number = PhoneNumber.create! name: 'Gui', city_code: '11', number: '40028922'

        first_inn_phone_number = InnPhoneNumber.create! phone_number: phone_number, inn: inn
        second_inn_phone_number = InnPhoneNumber.new phone_number: phone_number, inn: inn

        expect(second_inn_phone_number).not_to be_valid
      end
    end
  end
end
