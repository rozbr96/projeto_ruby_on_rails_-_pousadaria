
describe 'User visits the inn creation page' do
  context 'when authenticated as an innkeeper' do
    before :all do
      @innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com',
        password: 'password'
    end

    after :all do
      Innkeeper.delete_all
    end

    it 'automatically after signing in' do
      visit new_innkeeper_session_path

      within 'form' do
        fill_in 'E-mail', with: @innkeeper.email
        fill_in 'Senha', with: @innkeeper.password
        click_on 'Log in'
      end

      expect(current_path).to eq new_own_inn_path
    end

    it 'and sees the creation form' do
      login_as @innkeeper

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

        expect(page).to have_field 'Rua'
        expect(page).to have_field 'Número'
        expect(page).to have_field 'Complemento'
        expect(page).to have_field 'Bairro'
        expect(page).to have_field 'Cidade'
        expect(page).to have_field 'Estado'
        expect(page).to have_field 'CEP'
      end
    end

    it 'and creates the inn successfully' do
      login_as @innkeeper

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

        fill_in 'Rua', with: 'Rua Galática'
        fill_in 'Número', with: '42'
        fill_in 'Complemento', with: 'Shaka'
        fill_in 'Bairro', with: 'Virgem'
        fill_in 'Cidade', with: 'Terra'
        fill_in 'Estado', with: 'Via Láctea'
        fill_in 'CEP', with: '01.137-000'

        click_on 'Criar Pousada'
      end

      expect(current_path).to eq own_inn_path
      expect(page).to have_content 'Pousada criada com sucesso'
      expect(page).to have_content 'Pousada Universal'
      expect(page).to have_content 'Pousada universal...'
      expect(page).to have_content 'Rua Galática'
    end

    it 'fails to create the inn, seeing the related errors' do
      Inn.create! name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
        registration_number: '11338082000103', description: 'Pousada universal...',
        pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
        email: 'pousada.universal@test.com', enabled: false, innkeeper: @innkeeper,
        check_in: '10:00', check_out: '10:00'

      login_as @innkeeper

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

        fill_in 'Rua', with: ''
        fill_in 'Número', with: '42'
        fill_in 'Complemento', with: 'Shaka'
        fill_in 'Bairro', with: 'Virgem'
        fill_in 'Cidade', with: 'Terra'
        fill_in 'Estado', with: 'Via Láctea'
        fill_in 'CEP', with: '01.137-000'

        click_on 'Criar Pousada'
      end

      expect(page).to have_content 'Erro ao cadastrar pousada'
      expect(page).to have_content 'Nome Fantasia não pode ficar em branco'
      expect(page).to have_content 'Rua não pode ficar em branco'
      expect(page).to have_content 'Dono de Pousada já está em uso'
    end
  end
end
