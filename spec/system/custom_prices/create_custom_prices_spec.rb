
require 'rails_helper'

describe 'User visits own inn room custom price creation page' do
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
      login_as @innkeeper

      visit root_path

      within 'nav' do
        click_on @innkeeper.name
        click_on 'Minha Pousada'
      end

      click_on 'Visualizar Quartos'
      click_on 'Detalhes'
      click_on 'Adicionar Preço Especial'

      expect(current_path).to eq new_own_inn_room_custom_price_path @room
    end

    it 'and goes back to the room page' do
      login_as @innkeeper

      visit new_own_inn_room_custom_price_path @room

      click_on 'Voltar'

      expect(current_path).to eq own_inn_room_path @room
    end

    it 'and sees the custom price creation form' do
      login_as @innkeeper

      visit new_own_inn_room_custom_price_path @room

      within '#custom-price-form' do
        expect(page).to have_field 'Início'
        expect(page).to have_field 'Fim'
        expect(page).to have_field 'Diária'
      end
    end

    it 'and creates a new custom price successfully' do
      login_as @innkeeper

      visit new_own_inn_room_custom_price_path @room

      within '#custom-price-form' do
        fill_in 'Início', with: '20200101'
        fill_in 'Fim', with: '20200131'
        fill_in 'Diária', with: '20000'
        click_on 'Criar Preço Especial'
      end

      expect(current_path).to eq own_inn_room_path @room
      expect(page).to have_content 'Preço especial adicionado com sucesso'
      expect(page).to have_content '01/01/2020'
      expect(page).to have_content '31/01/2020'
      expect(page).to have_content 'R$ 200,00'
    end

    it 'and fails to create a new custom price, seeing the related errors' do
      login_as @innkeeper

      visit new_own_inn_room_custom_price_path @room

      within '#custom-price-form' do
        fill_in 'Início', with: '20200201'
        fill_in 'Fim', with: '20200131'
        fill_in 'Diária', with: '20000'
        click_on 'Criar Preço Especial'
      end

      expect(page).not_to have_content 'Preço especial adicionado com sucesso'
      expect(page).to have_content 'Erro ao adicionar preço especial'
      expect(page).to have_content 'Fim não pode ser anterior à data inicial'
    end

    it 'accessing a room price creation page for a not owned inn room' do
      second_innkeeper = FactoryBot.create :innkeeper
      second_inn = FactoryBot.create :inn, innkeeper: second_innkeeper
      FactoryBot.create :address, inn: second_inn
      second_room = FactoryBot.create :inn_room, inn: second_inn

      login_as @innkeeper

      visit new_own_inn_room_custom_price_path second_room

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
