
require 'rails_helper'

describe 'User visits the room edition page' do
  before :all do
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper
    FactoryBot.create :address, inn: inn
    @room = FactoryBot.create :inn_room, inn: inn
  end

  after :all do
    InnRoom.delete_all
    Address.delete_all
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
      click_on @room.name
      click_on 'Editar Quarto'

      expect(current_path).to eq edit_host_inn_room_path @room
    end

    it 'and goes back to the room details page' do
      login_as @innkeeper, scope: :innkeeper

      visit edit_host_inn_room_path @room

      click_on 'Voltar'

      expect(current_path).to eq host_inn_room_path @room
    end

    it 'and sees the edition form' do
      login_as @innkeeper, scope: :innkeeper

      visit edit_host_inn_room_path @room

      within 'form#inn-room-form' do
        expect(page).to have_field 'Nome', with: @room.name
        expect(page).to have_field 'Descrição', with: @room.description
        expect(page).to have_field 'Dimensão', with: @room.dimension
        expect(page).to have_field 'Diária', with: @room.price
        expect(page).to have_field 'Número Máximo de Convidados', with: @room.maximum_number_of_guests
        expect(page).to have_field 'Número de Banheiros', with: @room.number_of_bathrooms
        expect(page).to have_field 'Número de Guarda-roupas', with: @room.number_of_wardrobes
        expect(page).to have_field 'Possui sacada?', checked: @room.has_balcony?
        expect(page).to have_field 'Possui TV?', checked: @room.has_tv?
        expect(page).to have_field 'Possui Ar Condicionado?', checked: @room.has_air_conditioning?
        expect(page).to have_field 'Possui Cofre?', checked: @room.has_vault?
        expect(page).to have_field 'É acessível para pessoas com deficiência?', checked: @room.is_accessible_for_people_with_disabilities?
        expect(page).to have_field 'Habilitado?', checked: @room.enabled?
      end
    end

    it 'and edits the room successfully' do
      previous_description = @room.description
      previous_name = @room.name

      login_as @innkeeper, scope: :innkeeper

      visit edit_host_inn_room_path @room

      within 'form#inn-room-form' do
        fill_in 'Nome', with: 'Novo Nome para o Quarto'
        fill_in 'Descrição', with: 'Nova Descrição para o Quarto'
        click_on 'Atualizar Quarto de Pousada'
      end

      expect(current_path).to eq host_inn_room_path @room
      expect(page).not_to have_content previous_description
      expect(page).not_to have_content previous_name
      expect(page).to have_content 'Quarto atualizado com sucesso'
      expect(page).to have_content 'Novo Nome para o Quarto'
      expect(page).to have_content 'Nova Descrição para o Quarto'
    end

    it 'and fails to edit the room, seeing the related errors' do
      login_as @innkeeper, scope: :innkeeper

      visit edit_host_inn_room_path @room

      within 'form#inn-room-form' do
        fill_in 'Nome', with: 'Novo Nome para o Quarto'
        fill_in 'Descrição', with: ''
        click_on 'Atualizar Quarto de Pousada'
      end

      expect(page).not_to have_content 'Quarto atualizado com sucesso'
      expect(page).to have_content 'Erro ao atualizar quarto'
      expect(page).to have_field 'Nome', with: 'Novo Nome para o Quarto'
      expect(page).to have_field 'Descrição', with: ''
      expect(page).to have_content 'Descrição não pode ficar em branco'
    end

    it 'trying to get to the room of a not owed inn' do
      second_innkeeper = FactoryBot.create :innkeeper
      second_inn = FactoryBot.create :inn, innkeeper: second_innkeeper, enabled: true
      FactoryBot.create :address, inn: second_inn
      second_room = FactoryBot.create :inn_room, inn: second_inn

      login_as @innkeeper, scope: :innkeeper

      visit edit_host_inn_room_path second_room

      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não tem permissão para acessar essa página'
    end
  end
end
