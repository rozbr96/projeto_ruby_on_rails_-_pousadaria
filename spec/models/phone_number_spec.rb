require 'rails_helper'

RSpec.describe PhoneNumber, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'should fail if name is empty' do
        phone = PhoneNumber.new name: '', city_code: '11', number: '40028922'

        expect(phone).not_to be_valid
      end

      it 'should fail if city_code is empty' do
        phone = PhoneNumber.new name: 'Gui', city_code: '', number: '40028922'

        expect(phone).not_to be_valid
      end

      it 'should fail if number is empty' do
        phone = PhoneNumber.new name: 'Gui', city_code: '11', number: ''

        expect(phone).not_to be_valid
      end
    end

    context 'uniqueness' do
      it 'should fail if number and city code are already in use' do
        first_phone = PhoneNumber.create! name: 'Gui', city_code: '11', number: '40028922'
        second_phone = PhoneNumber.new name: 'Alẽ', city_code: '11', number: '40028922'

        expect(second_phone).not_to be_valid
      end

      it 'should not fail if only number is already in use' do
        first_phone = PhoneNumber.create! name: 'Gui', city_code: '11', number: '40028922'
        second_phone = PhoneNumber.new name: 'Alẽ', city_code: '10', number: '40028922'

        expect(second_phone).to be_valid
      end
    end
  end
end
