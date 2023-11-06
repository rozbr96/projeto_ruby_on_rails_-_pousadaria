
require 'rails_helper'

describe 'User visits listing rooms page' do
  context 'when authenticated as innkeeper' do
    before :all do
      @innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'

      @inn = Inn.create! name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
        registration_number: '11338082000103', description: 'Pousada universal...',
        pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
        email: 'pousada.universal@test.com', enabled: false, innkeeper: @innkeeper,
        check_in: '10:00', check_out: '10:00'

      Address.create! street: 'Rua Galática', number: '42',
        neighbourhood: 'Virgem', city: 'Terra', state: 'Via Láctea',
        postal_code: '01.137-000', complement: 'Shaka', inn: @inn
    end

    after :all do
      Address.destroy_all
      Inn.destroy_all
      Innkeeper.destroy_all
    end

    it 'from the home page' do
      login_as @innkeeper

      visit root_path

      within 'nav' do
        click_on @innkeeper.name
        click_on 'Minha Pousada'
      end

      click_on 'Visualizar Quartos'

      expect(current_path).to eq own_inn_rooms_path
    end

    it 'and goes back to the inn details page' do
      login_as @innkeeper

      visit own_inn_rooms_path

      click_on 'Voltar'

      expect(current_path).to eq own_inn_path
    end

    it 'and sees no existing rooms' do
      login_as @innkeeper

      visit own_inn_rooms_path

      within '#inn-rooms-table' do
        expect(page).to have_content 'Nenhum quarto registrado'
      end
    end

    it 'and sees existing rooms' do
      room = InnRoom.create! name: 'Sol', description: 'Quarto arejado com vista para o mar',
        dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
        number_of_wardrobes: 2, has_balcony: true, has_tv: true, has_air_conditioning: false,
        has_vault: false, is_accessible_for_people_with_disabilities: true, inn: @inn,
        enabled: true

      login_as @innkeeper

      visit own_inn_rooms_path

      within '#inn-rooms-table' do
        expect(page).to have_content 'Sol'
        expect(page).to have_content 'SIM'
      end
    end
  end

  context 'when the user is not authenticated' do
    it 'should be redirected to the login page' do
      visit own_inn_rooms_path

      expect(current_path).to eq new_innkeeper_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se'
    end
  end
end
