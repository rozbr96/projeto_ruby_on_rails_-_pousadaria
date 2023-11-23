
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
    it 'and sees no existing custom prices' do
      login_as @innkeeper, scope: :innkeeper

      visit host_inn_room_path @room

      expect(page).to have_content 'Preços por temporada'
      expect(page).to have_content 'Nenhum preço especial encontrado'
    end

    it 'and sees existing custom prices' do
      CustomPrice.create! start_date: '2020-12-27', end_date: '2021-01-05',
        price: 200_00, inn_room: @room

      login_as @innkeeper, scope: :innkeeper

      visit host_inn_room_path @room

      expect(page).not_to have_content 'Nenhum preço especial encontrado'
      expect(page).to have_content '27/12/2020'
      expect(page).to have_content '05/01/2021'
      expect(page).to have_content 'R$ 200,00'
    end
  end

  context 'when not logged in' do
    it 'should be redirected to login page' do
      visit host_inn_room_path @room

      expect(current_path).to eq new_innkeeper_session_path
    end
  end
end
