require 'rails_helper'

RSpec.describe Guest, type: :model do
  describe '#valid?' do
    context 'presence' do
      it 'should be invalid when name is empty' do
        guest = Guest.new name: '', citizen_number: '11111111111',
          email: 'guest@test.net', password: 'password'

        expect(guest).not_to be_valid
      end

      it 'should be invalid when citizen number is empty' do
        guest = Guest.new name: 'Guest', citizen_number: '',
          email: 'guest@test.net', password: 'password'

        expect(guest).not_to be_valid
      end
    end

    context 'uniqueness' do
      it 'should be invalid when citizen number is alread in use' do
        Guest.create! name: 'First Guest', citizen_number: '11111111111',
          email: 'first_guest@test.net', password: 'password'

        guest = Guest.new name: 'Second Guest', citizen_number: '11111111111',
          email: 'second_guest@test.net', password: 'drowssap'

        expect(guest).not_to be_valid
      end
    end
  end
end
