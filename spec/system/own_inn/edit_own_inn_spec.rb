
require 'rails_helper'

describe 'User visits own inn edit page' do
  context 'When logged in as innkeeper' do
    before :all do
      @innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com',
        password: 'password'

      payment_using_pix = PaymentMethod.create! name: 'PIX', enabled: true
      payment_using_card = PaymentMethod.create! name: 'Cartão', enabled: true
      payment_using_cash = PaymentMethod.create! name: 'Dinheiro', enabled: true

      payment_methods = [
        payment_using_pix,
        payment_using_cash
      ]

      address = Address.new street: 'Rua Galática', number: '42',
        neighbourhood: 'Virgem', city: 'Terra', state: 'Via Láctea',
        postal_code: '01.137-000', complement: 'Shaka'

      @inn = Inn.create! name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
        registration_number: '11338082000103', description: 'Pousada universal...',
        pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
        email: 'pousada.universal@test.com', enabled: false, innkeeper: @innkeeper,
        check_in: '10:00', check_out: '10:00', address: address, payment_methods: payment_methods
    end

    after :all do
      InnPaymentMethod.delete_all
      PaymentMethod.delete_all
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

      click_on 'Editar Pousada'

      expect(current_path).to eq edit_own_inn_path
    end

    it 'and goes back to the inn details page' do
      login_as @innkeeper, scope: :innkeeper

      visit edit_own_inn_path

      click_on 'Voltar'

      expect(current_path).to eq own_inn_path
    end

    it 'and sees the edition form' do
      login_as @innkeeper, scope: :innkeeper

      visit edit_own_inn_path

      within '#inn-form' do
        expect(page).to have_field 'Nome Fantasia'
        expect(page).to have_field 'Razão Social'
        expect(page).to have_field 'CNPJ'
        expect(page).to have_field 'Descrição'
        expect(page).to have_field 'Animais são permitidos?'
        expect(page).to have_field 'Polítias de Uso'
        expect(page).to have_field 'E-mail'
        expect(page).to have_field 'Habilitada'
        expect(page).to have_field 'Check in'
        expect(page).to have_field 'Check out'

        within '#address-wrapper' do
          expect(page).to have_field 'Rua'
          expect(page).to have_field 'Número'
          expect(page).to have_field 'Complemento'
          expect(page).to have_field 'Bairro'
          expect(page).to have_field 'Cidade'
          expect(page).to have_field 'Estado'
          expect(page).to have_field 'CEP'
        end

        within '#payment-methods-wrapper' do
          expect(page).to have_field 'Cartão'
          expect(page).to have_field 'Dinheiro'
          expect(page).to have_field 'PIX'
        end

        1.upto(3).each do |index|
          within "#phone-numbers-wrapper > .phone-number:nth-child(#{index})" do
            expect(page).to have_field 'Falar com'
            expect(page).to have_field 'DDD'
            expect(page).to have_field 'Número'
          end
        end
      end
    end

    it 'and updates the inn successfully' do
      login_as @innkeeper, scope: :innkeeper

      visit edit_own_inn_path

      within '#inn-form' do
        fill_in 'Nome Fantasia', with: 'Pousada Universal'
        fill_in 'Razão Social', with: 'Pousada Universal LTDA'
        fill_in 'CNPJ', with: '11338082000103'
        fill_in 'Descrição', with: 'Pousada universal...'
        uncheck 'Animais são permitidos?'
        fill_in 'Polítias de Uso', with: 'Está estritamente proibido...'
        fill_in 'E-mail', with: 'pousada.universal@test.com'
        check 'Habilitada'
        fill_in 'Check in', with: '10:00'
        fill_in 'Check out', with: '10:00'

        within '#address-wrapper' do
          fill_in 'Rua', with: 'Rua Explosão Galática'
          fill_in 'Número', with: '42'
          fill_in 'Complemento', with: 'Shaka'
          fill_in 'Bairro', with: 'Virgem'
          fill_in 'Cidade', with: 'Terra'
          fill_in 'Estado', with: 'Via Láctea'
          fill_in 'CEP', with: '01.137-000'
        end

        within "#phone-numbers-wrapper > .phone-number:nth-child(1)" do
          fill_in 'Falar com', with: 'Gui'
          fill_in 'DDD', with: '11'
          fill_in 'Número', with: '4002-8922'
        end

        within "#phone-numbers-wrapper > .phone-number:nth-child(2)" do
          fill_in 'Falar com', with: ''
          fill_in 'DDD', with: ''
          fill_in 'Número', with: ''
        end

        click_on 'Atualizar Pousada'
      end

      expect(current_path).to eq own_inn_path
      expect(page).to have_content 'Pousada atualizada com sucesso'
      expect(page).to have_content 'Pousada Universal'
      expect(page).to have_content 'Pousada universal...'
      expect(page).to have_content 'Rua Explosão Galática'
      expect(page).to have_content '(11) 4002-8922'
      expect(page).not_to have_content '(11) 49922'
    end
  end

  context 'When user is not logged as innkeeper' do
    it 'should be redirected to the login page' do
      visit edit_own_inn_path

      expect(current_path).to eq new_innkeeper_session_path
    end
  end
end
