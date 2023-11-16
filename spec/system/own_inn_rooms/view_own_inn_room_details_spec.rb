
require 'rails_helper'

describe 'User visits own inn room details page' do
  before :all do
    @innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'

    address = Address.new street: 'Rua Galática', number: '42', neighbourhood: 'Virgem',
      city: 'Terra', state: 'Via Láctea', postal_code: '01.137-000',
      complement: 'Shaka'

    inn = Inn.create! name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
      registration_number: '11338082000103', description: 'Pousada universal...',
      pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
      email: 'pousada.universal@test.com', enabled: false, innkeeper: @innkeeper,
      check_in: '10:00', check_out: '10:00', address: address

    @room = InnRoom.create! name: 'Beira Mar', description: 'Quarto arejado com vista para o mar',
      dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
      number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
      has_vault: false, is_accessible_for_people_with_disabilities: true, inn: inn
  end

  after :all do
    Address.delete_all
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  context 'when logged in as innkeeper' do
    it 'from the home page' do
      login_as @innkeeper, scope: :innkeeper

      visit root_path

      within 'nav' do
        click_on @innkeeper.name
        click_on 'Minha Pousada'
      end

      click_on 'Visualizar Quartos'
      click_on 'Detalhes'

      expect(current_path).to eq own_inn_room_path @room
    end

    it 'and goes back to rooms listing page' do
      login_as @innkeeper, scope: :innkeeper

      visit own_inn_room_path @room

      click_on 'Voltar'

      expect(current_path).to eq own_inn_rooms_path
    end

    it 'and sees all info' do
      login_as @innkeeper, scope: :innkeeper

      visit own_inn_room_path @room

      expect(page).to have_content 'Beira Mar'
      expect(page).to have_content 'Quarto arejado com vista para o mar'
      expect(page).to have_content '100 m²'
      expect(page).to have_content 'R$ 150,00'
    end

    it 'trying to get to the room of a not owed inn' do
      second_innkeeper = FactoryBot.create :innkeeper
      second_inn = FactoryBot.create :inn, innkeeper: second_innkeeper, enabled: true
      FactoryBot.create :address, inn: second_inn
      second_room = FactoryBot.create :inn_room, inn: second_inn

      login_as @innkeeper, scope: :innkeeper

      visit own_inn_room_path second_room

      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não tem permissão para acessar essa página'
    end
  end

  context 'when not logged in' do
    it 'should be redirected to login page' do
      visit own_inn_room_path @room

      expect(current_path).to eq new_innkeeper_session_path
    end
  end
end
