
describe 'User visits registration page' do
  it 'from the home page' do
    visit root_path

    within 'nav' do
      click_on 'Entrar'
      click_on 'Como Dono de Pousada'
    end

    click_on 'Criar Conta'

    expect(current_path).to eq new_innkeeper_registration_path
  end

  it 'and sees the registration form' do
    visit new_innkeeper_registration_path

    within 'form' do
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'E-mail'
      expect(page).to have_field 'Senha'
      expect(page).to have_field 'Confirme sua senha'
    end
  end

  it 'and creates an account successfully' do
    visit new_innkeeper_registration_path

    within 'form' do
      fill_in 'Nome', with: 'Gui'
      fill_in 'E-mail', with: 'gui@test.com'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      click_on 'Cadastrar'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Boas vindas! Você realizou seu registro com sucesso'

    within 'nav' do
      expect(page).to have_content 'Gui'
    end
  end

  it 'and fails to create an account, seeing the related errors' do
    visit new_innkeeper_registration_path

    within 'form' do
      fill_in 'Nome', with: ''
      fill_in 'E-mail', with: 'gui2test.com'
      fill_in 'Senha', with: '123456'
      fill_in 'Confirme sua senha', with: '12345'
      click_on 'Cadastrar'
    end

    expect(page).not_to have_content 'Boas vindas! Você realizou seu registro com sucesso'
    expect(page).to have_content 'Não foi possível salvar'
    expect(page).to have_content 'Confirme sua senha não é igual a Senha'
    expect(page).to have_content 'E-mail não é válido'
  end
end
