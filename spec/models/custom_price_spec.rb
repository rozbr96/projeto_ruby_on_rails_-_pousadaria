require 'rails_helper'

RSpec.describe CustomPrice, type: :model do
  describe '#valid' do
    before :all do
      innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'
      inn = Inn.create! name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
        registration_number: '11338082000103', description: 'Pousada universal...',
        pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
        email: 'pousada.universal@test.com', enabled: false, innkeeper: innkeeper,
        check_in: '10:00', check_out: '10:00'

      @room = InnRoom.create! name: 'Sol', description: 'Quarto arejado com vista para o mar',
        dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
        number_of_wardrobes: 2, has_balcony: nil, has_tv: true, has_air_conditioning: false,
        has_vault: false, is_accessible_for_people_with_disabilities: true, inn: inn
    end

    after :all do
      InnRoom.delete_all
      Inn.delete_all
      Innkeeper.delete_all
    end

    context 'presence' do
      it 'should be invalid when start_date is empty' do
        custom_price = CustomPrice.new start_date: '', end_date: '2020-12-10',
          price: 10000, inn_room: @room

        expect(custom_price).not_to be_valid
      end

      it 'should be invalid when end is empty' do
        custom_price = CustomPrice.new start_date: '2020-10-10', end_date: '',
          price: 10000, inn_room: @room

        expect(custom_price).not_to be_valid
      end

      it 'should be invalid when price is empty' do
        custom_price = CustomPrice.new start_date: '2020-10-10', end_date: '2020-12-10',
          price: nil, inn_room: @room

        expect(custom_price).not_to be_valid
      end
    end

    context 'overlaping' do
      it 'should be invalid when an overlapping occurs' do
        CustomPrice.create! start_date: '2020-10-10', end_date: '2020-12-10',
          price: 10000, inn_room: @room

        room_custom_price = CustomPrice.new start_date: '2020-12-10', price: 10000,
          end_date: '2021-02-10', inn_room: @room

        expect(room_custom_price).not_to be_valid
      end
    end

    context 'start and end dates' do
      it 'should be invalid when end_date is after start_date' do
        room_custom_price = CustomPrice.new start_date: '2021-12-10', price: 10000,
          end_date: '2021-12-09', inn_room: @room

        expect(room_custom_price).not_to be_valid
      end
    end
  end
end
