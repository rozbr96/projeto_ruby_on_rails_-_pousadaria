
require 'rails_helper'

describe 'User visits the registration page' do
  it 'from the home page' do
    visit root_path

    within 'nav' do
      click_on 'Entrar'
      click_on 'Como Hóspede'
    end

    click_on 'Criar Conta'

    expect(current_path).to eq new_guest_registration_path
  end

  it 'and sees the registration form' do
    visit new_guest_registration_path

    within 'form#new_guest' do
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'CPF'
      expect(page).to have_field 'E-mail'
      expect(page).to have_field 'Senha'
      expect(page).to have_field 'Confirme sua senha'
    end
  end

  it 'and signs up successfully' do
    visit new_guest_registration_path

    within 'form#new_guest' do
      fill_in 'Nome', with: 'Gui'
      fill_in 'CPF', with: '11111111111'
      fill_in 'E-mail', with: 'gui@test.net'
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
end
