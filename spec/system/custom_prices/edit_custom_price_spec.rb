
require 'rails_helper'

describe 'User visit custom price edition' do
  before :all do
    @innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'

    inn = Inn.create! name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
      registration_number: '11338082000103', description: 'Pousada universal...',
      pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
      email: 'pousada.universal@test.com', enabled: false, innkeeper: @innkeeper,
      check_in: '10:00', check_out: '10:00'

    address = Address.create! street: 'Rua Galática', number: '42', neighbourhood: 'Virgem',
      city: 'Terra', state: 'Via Láctea', postal_code: '01.137-000',
      complement: 'Shaka', inn: inn

    @room = InnRoom.create! name: 'Sol', description: 'Quarto arejado com vista para o mar',
      dimension: 100, price: 15_000, maximum_number_of_guests: 4, number_of_bathrooms: 1,
      number_of_wardrobes: 2, has_balcony: nil, has_tv: true, has_air_conditioning: false,
      has_vault: false, is_accessible_for_people_with_disabilities: true, inn: inn

    @custom_price = CustomPrice.create! start_date: '2020-01-01', end_date: '2020-01-20',
      price: 200_00, inn_room: @room
  end

  after :all do
    CustomPrice.delete_all
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

      within '#custom-prices' do
        click_on 'Editar'
      end

      expect(current_path).to eq edit_own_inn_room_custom_price_path(@room, @custom_price)
    end

    it 'and goes back' do
      login_as @innkeeper, scope: :innkeeper

      visit edit_own_inn_room_custom_price_path(@room, @custom_price)

      click_on 'Voltar'

      expect(current_path).to eq own_inn_room_path @room
    end

    it 'and sees the edition form' do
      login_as @innkeeper, scope: :innkeeper

      visit edit_own_inn_room_custom_price_path(@room, @custom_price)

      within '#custom-price-form' do
        expect(page).to have_field 'Início'
        expect(page).to have_field 'Fim'
        expect(page).to have_field 'Diária'
      end
    end

    it 'and updates the custom price successfully' do
      login_as @innkeeper, scope: :innkeeper

      visit edit_own_inn_room_custom_price_path(@room, @custom_price)

      within '#custom-price-form' do
        fill_in 'Fim', with: '2020-01-31'
        fill_in 'Diária', with: '17500'
        click_on 'Atualizar Preço Especial'
      end

      expect(current_path).to eq own_inn_room_path @room
      expect(page).to have_content 'Preço especial atualizado com sucesso'
      expect(page).to have_content 'R$ 175,00'
      expect(page).not_to have_content 'R$ 200,00'
      expect(page).to have_content '31/01/2020'
      expect(page).not_to have_content '20/01/2020'
    end

    it 'and fails to update the price, seeing the related errors' do
      login_as @innkeeper, scope: :innkeeper

      visit edit_own_inn_room_custom_price_path(@room, @custom_price)

      within '#custom-price-form' do
        fill_in 'Fim', with: '2019-12-31'
        fill_in 'Diária', with: '17500'
        click_on 'Atualizar Preço Especial'
      end

      expect(page).to have_content 'Erro ao atualizar preço especial'
      expect(page).to have_content 'Fim não pode ser anterior à data inicial'
    end

    it 'accessing a room price edition page for a not owned inn room' do
      second_innkeeper = FactoryBot.create :innkeeper
      second_inn = FactoryBot.create :inn, innkeeper: second_innkeeper
      FactoryBot.create :address, inn: second_inn
      second_room = FactoryBot.create :inn_room, inn: second_inn
      second_price = FactoryBot.create :custom_price, inn_room: second_room

      login_as @innkeeper, scope: :innkeeper

      visit edit_own_inn_room_custom_price_path(second_room, second_price)

      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não tem permissão para acessar essa página'
    end
  end

  context 'when not logged' do
    it 'should be redirected to the login page' do
      visit edit_own_inn_room_custom_price_path(@room, @custom_price)

      expect(current_path).to eq new_innkeeper_session_path
    end
  end
end
