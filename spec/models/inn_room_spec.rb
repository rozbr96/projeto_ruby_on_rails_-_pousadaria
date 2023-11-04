require 'rails_helper'

RSpec.describe InnRoom, type: :model do
  before :all do
    innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'
    @inn = Inn.create! name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
      registration_number: '11338082000103', description: 'Pousada universal...',
      pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
      email: 'pousada.universal@test.com', enabled: false, innkeeper: innkeeper,
      check_in: '10:00', check_out: '10:00'
  end

  after :all do
    Inn.destroy_all
    Innkeeper.destroy_all
  end

  describe '#valid' do
    context 'presence' do
      it 'should be invalid when name is empty' do
        room = InnRoom.new name: '', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room).not_to be_valid
      end

      it 'should be invalid when description is empty' do
        room = InnRoom.new name: 'Sol', description: '',
          dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room).not_to be_valid
      end

      it 'should be invalid when dimension is empty' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: '', price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room).not_to be_valid
      end

      it 'should be invalid when price is empty' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: '', maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room).not_to be_valid
      end

      it 'should be invalid when maximum_number_of_guests is empty' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: 15_000, maximum_number_of_guests: '', number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room).not_to be_valid
      end

      it 'should be invalid when number_of_bathrooms is empty' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: '',
          number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room).not_to be_valid
      end

      it 'should be invalid when number_of_wardrobes is empty' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: '', has_balcony: true, has_tv: true, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room).not_to be_valid
      end
    end
  end

  context 'default values' do
    describe '#has_balcony' do
      it 'should fail if has_balcony is not false' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: nil, has_tv: true, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room.has_balcony).to eq false
      end
    end

    describe '#has_tv' do
      it 'should fail if has_tv is not false' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: true, has_tv: nil, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room.has_tv).to eq false
      end
    end

    describe '#has_air_conditioning' do
      it 'should fail if has_air_conditioning is not false' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: nil,
          has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room.has_air_conditioning).to eq false
      end
    end

    describe '#has_vault' do
      it 'should fail if has_vault is not false' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
          has_vault: nil, is_accessible_for_people_with_disabilities: true, inn: @inn

        expect(room.has_vault).to eq false
      end
    end

    describe '#is_accessible_for_people_with_disabilities' do
      it 'should fail if is_accessible_for_people_with_disabilities is not false' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: nil, inn: @inn

        expect(room.is_accessible_for_people_with_disabilities).to eq false
      end
    end

    describe '#enabled' do
      it 'should fail if enabled is not false' do
        room = InnRoom.new name: 'Sol', description: 'Quarto arejado com vista para o mar',
          dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
          number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
          has_vault: false, is_accessible_for_people_with_disabilities: nil, inn: @inn,
          enabled: nil

        expect(room.enabled).to eq false
      end
    end
  end
end
