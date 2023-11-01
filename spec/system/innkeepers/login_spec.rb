
require 'rails_helper'

describe 'User visits login page' do
  it 'from the home page' do
    visit root_path

    within 'nav' do
      click_on 'Entrar'
      click_on 'Como Dono de Pousada'
    end

    expect(current_path).to eq new_innkeeper_session_path
  end

  it 'and sees the login form' do
    visit new_innkeeper_session_path

    within 'form' do
      expect(page).to have_field 'E-mail'
      expect(page).to have_field 'Senha'
    end
  end

  it 'and logins successfully' do
    innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: '12345678'

    visit new_innkeeper_session_path

    within 'form' do
      fill_in 'E-mail', with: innkeeper.email
      fill_in 'Senha', with: innkeeper.password
      click_on 'Log in'
    end

    expect(current_path).to eq root_path

    within '.alert-success' do
      expect(page).to have_content 'Login efetuado com sucesso'
    end
  end

  it 'and fails to login, seeing the related errors' do
    innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: '12345678'

    visit new_innkeeper_session_path

    within 'form' do
      fill_in 'E-mail', with: innkeeper.email
      fill_in 'Senha', with: 'wrong password'
      click_on 'Log in'
    end

    expect(current_path).to eq new_innkeeper_session_path
    expect(page).not_to have_content 'Login efetuado com sucesso'

    within '.alert-danger' do
      expect(page).to have_content 'E-mail ou senha inválidos'
    end
  end
end
