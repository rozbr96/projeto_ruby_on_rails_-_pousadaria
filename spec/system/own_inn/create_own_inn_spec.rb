
describe 'User visits the inn creation page' do
  context 'when authenticated as an innkeeper' do
    before :all do
      ['Dinheiro', 'PIX', 'Cartão'].each do |payment_method|
        PaymentMethod.create! name: payment_method, enabled: true
      end

      @innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com',
        password: 'password'
    end

    after :all do
      PaymentMethod.delete_all
      Innkeeper.delete_all
    end

    it 'automatically after signing in' do
      visit new_innkeeper_session_path

      within 'form#new_innkeeper' do
        fill_in 'E-mail', with: @innkeeper.email
        fill_in 'Senha', with: @innkeeper.password
        click_on 'Log in'
      end

      expect(current_path).to eq new_own_inn_path

      within '.alert.alert-warning' do
        expect(page).to have_content 'Primeiro é necessário registrar sua pousada'
      end
    end

    it 'and sees the creation form' do
      login_as @innkeeper, scope: :innkeeper

      visit new_own_inn_path

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

    it 'and creates the inn successfully' do
      login_as @innkeeper, scope: :innkeeper

      visit new_own_inn_path

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
          fill_in 'Rua', with: 'Rua Galática'
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
          fill_in 'Número', with: '40028922'
        end

        within "#phone-numbers-wrapper > .phone-number:nth-child(2)" do
          fill_in 'Falar com', with: 'Gui'
          fill_in 'DDD', with: '11'
          fill_in 'Número', with: '49922'
        end

        click_on 'Criar Pousada'
      end

      expect(current_path).to eq own_inn_path
      expect(page).to have_content 'Pousada criada com sucesso'
      expect(page).to have_content 'Pousada Universal'
      expect(page).to have_content 'Pousada universal...'
      expect(page).to have_content 'Rua Galática'
      expect(page).to have_content '(11) 40028922'
      expect(page).to have_content '(11) 49922'
    end

    it 'fails to create the inn, seeing the related errors' do
      login_as @innkeeper, scope: :innkeeper

      visit new_own_inn_path

      within '#inn-form' do
        fill_in 'Nome Fantasia', with: ''
        fill_in 'Razão Social', with: 'Pousada Universal LTDA'
        fill_in 'CNPJ', with: '11338082000103'
        fill_in 'Descrição', with: 'Pousada universal...'
        check 'Animais são permitidos?'
        fill_in 'Polítias de Uso', with: 'Está estritamente proibido...'
        fill_in 'E-mail', with: 'pousada.universal@test.com'
        check 'Habilitada'
        fill_in 'Check in', with: '10:00'
        fill_in 'Check out', with: '10:00'

        within '#address-wrapper' do
          fill_in 'Rua', with: ''
          fill_in 'Número', with: '42'
          fill_in 'Complemento', with: 'Shaka'
          fill_in 'Bairro', with: 'Virgem'
          fill_in 'Cidade', with: 'Terra'
          fill_in 'Estado', with: 'Via Láctea'
          fill_in 'CEP', with: '01.137-000'
        end

        within "#phone-numbers-wrapper > .phone-number:nth-child(1)" do
          fill_in 'Falar com', with: ''
          fill_in 'DDD', with: '11'
          fill_in 'Número', with: '40028922'
        end

        click_on 'Criar Pousada'
      end

      expect(page).to have_content 'Erro ao cadastrar pousada'
      expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
      expect(page).to have_content 'Rua não pode ficar em branco'
      expect(page).to have_content 'Falar com não pode ficar em branco'
    end
  end

  context 'when the user is not authenticated' do
    it 'should be redirected to the login page' do
      visit new_own_inn_path

      expect(current_path).to eq new_innkeeper_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se'
    end
  end
end
