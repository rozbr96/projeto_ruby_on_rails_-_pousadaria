
describe 'User visits his own inn details page' do
  context 'when logged in as an innkeeper' do
    before :all do
      @innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com',
        password: 'password'

      address = Address.new street: 'Rua Galática', number: '42',
        neighbourhood: 'Virgem', city: 'Terra', state: 'Via Láctea',
        postal_code: '01.137-000', complement: 'Shaka'

      inn = Inn.create! name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
        registration_number: '11338082000103', description: 'Pousada universal...',
        pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
        email: 'pousada.universal@test.com', enabled: false, innkeeper: @innkeeper,
        check_in: '10:00', check_out: '10:00', address: address
    end

    after :all do
      Address.delete_all
      Inn.delete_all
      Innkeeper.delete_all
    end

    it 'from the home page and sees the details' do
      login_as @innkeeper, scope: :innkeeper

      visit root_path

      within 'nav' do
        click_on @innkeeper.name
        click_on 'Minha Pousada'
      end

      expect(current_path).to eq own_inn_path
      expect(page).to have_content 'Rua Galática'
      expect(page).to have_content '01.137-000'
      expect(page).to have_content 'Pousada Universal'
      expect(page).to have_content 'Pousada Universal LTDA'
      expect(page).to have_content 'Está estritamente proibido...'
      expect(page).to have_content 'pousada.universal@test.com'
      expect(page).to have_content '10:00'
    end

    it 'automatically when trying to access the inn creation page' do
      login_as @innkeeper, scope: :innkeeper

      visit new_own_inn_path

      expect(current_path).to eq own_inn_path
      expect(page).to have_content 'Sua pousada já está cadastrada'
    end
  end

  context 'when the user is not authenticated' do
    it 'should be redirected to the login page' do
      visit own_inn_path

      expect(current_path).to eq new_innkeeper_session_path
      expect(page).to have_content 'Para continuar, faça login ou registre-se'
    end
  end
end
