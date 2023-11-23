
require 'rails_helper'

describe 'User visits room creation page' do
  context 'when logged in as innkeeper' do
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
      Address.delete_all
      Inn.delete_all
      Innkeeper.delete_all
    end

    it 'from the home page' do
      login_as @innkeeper, scope: :innkeeper

      visit root_path

      within 'nav' do
        click_on @innkeeper.name
        click_on 'Minha Pousada'
      end

      click_on 'Visualizar Quartos'
      click_on 'Registrar Quarto'

      expect(current_path).to eq new_host_inn_room_path
    end

    it 'and goes back to the inn rooms page' do
      login_as @innkeeper, scope: :innkeeper

      visit new_host_inn_room_path

      click_on 'Voltar'

      expect(current_path).to eq host_inn_rooms_path
    end

    it 'and sees the registration form' do
      login_as @innkeeper, scope: :innkeeper

      visit new_host_inn_room_path

      within 'form#inn-room-form' do
        expect(page).to have_field 'Nome'
        expect(page).to have_field 'Descrição'
        expect(page).to have_field 'Dimensão'
        expect(page).to have_field 'Diária'
        expect(page).to have_field 'Número Máximo de Convidados'
        expect(page).to have_field 'Número de Banheiros'
        expect(page).to have_field 'Número de Guarda-roupas'
        expect(page).to have_field 'Possui sacada?'
        expect(page).to have_field 'Possui TV?'
        expect(page).to have_field 'Possui Ar Condicionado?'
        expect(page).to have_field 'Possui Cofre?'
        expect(page).to have_field 'É acessível para pessoas com deficiência?'
        expect(page).to have_field 'Habilitado?'
      end
    end

    it 'and creates the room successfully' do
      login_as @innkeeper, scope: :innkeeper

      visit new_host_inn_room_path

      within 'form#inn-room-form' do
        fill_in 'Nome', with: 'Sol'
        fill_in 'Descrição', with: 'Quarto arejado, com vista para o mar...'
        fill_in 'Dimensão', with: '400'
        fill_in 'Diária', with: '40000'
        fill_in 'Número Máximo de Convidados', with: '4'
        fill_in 'Número de Banheiros', with: '2'
        fill_in 'Número de Guarda-roupas', with: '2'
        check 'Possui sacada?'
        check 'Possui TV?'
        uncheck 'Possui Ar Condicionado?'
        uncheck 'Possui Cofre?'
        uncheck 'É acessível para pessoas com deficiência?'
        check 'Habilitado?'
        click_on 'Criar Quarto de Pousada'
      end

      expect(current_path).to eq host_inn_room_path InnRoom.last
      expect(page).to have_content 'Quarto registrado com sucesso'
    end

    it 'and fails to create the room, seeing the related errors' do
      login_as @innkeeper, scope: :innkeeper

      visit new_host_inn_room_path

      within 'form#inn-room-form' do
        fill_in 'Nome', with: ''
        fill_in 'Descrição', with: 'Quarto arejado, com vista para o mar...'
        fill_in 'Dimensão', with: ''
        fill_in 'Diária', with: '40000'
        fill_in 'Número Máximo de Convidados', with: '4'
        fill_in 'Número de Banheiros', with: '2'
        fill_in 'Número de Guarda-roupas', with: '2'
        check 'Possui sacada?'
        check 'Possui TV?'
        uncheck 'Possui Ar Condicionado?'
        uncheck 'Possui Cofre?'
        uncheck 'É acessível para pessoas com deficiência?'
        check 'Habilitado?'
        click_on 'Criar Quarto de Pousada'
      end

      expect(page).to have_content 'Erro ao registrar quarto'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Dimensão não pode ficar em branco'
    end
  end

  context 'when the user is not authenticated' do
    it 'should be redirected to the login page' do
      visit new_host_inn_room_path

      expect(current_path).to eq new_innkeeper_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se'
    end
  end
end
