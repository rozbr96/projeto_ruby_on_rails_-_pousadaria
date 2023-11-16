
require 'rails_helper'

describe 'User visits the login page' do
  it 'from the home page' do
    visit root_path

    within 'nav' do
      click_on 'Entrar'
      click_on 'Como Hóspede'
    end

    expect(current_path).to eq new_guest_session_path
  end

  it 'and sees the login form' do
    visit new_guest_session_path

    within 'form#new_guest' do
      expect(page).to have_field 'E-mail'
      expect(page).to have_field 'Senha'
    end
  end

  it 'and logins successfully' do
    guest = FactoryBot.create :guest

    visit new_guest_session_path

    within 'form#new_guest' do
      fill_in 'E-mail', with: guest.email
      fill_in 'Senha', with: guest.password
      click_on 'Log in'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Login efetuado com sucesso'
  end

  it 'and fails to login' do
    guest = FactoryBot.create :guest, password: 'password'

    visit new_guest_session_path

    within 'form#new_guest' do
      fill_in 'E-mail', with: guest.email
      fill_in 'Senha', with: 'wrong password'
      click_on 'Log in'
    end

    expect(page).not_to have_content 'Login efetuado com sucesso'
    expect(page).to have_content 'E-mail ou senha inválidos'
  end
end
