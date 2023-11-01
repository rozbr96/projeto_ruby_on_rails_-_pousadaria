
require 'rails_helper'

describe 'User logouts' do
  it 'after opening the application' do
    innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'
    login_as innkeeper

    visit root_path

    within 'nav' do
      click_on innkeeper.name
      click_on 'Sair'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Logout efetuado com sucesso'
  end
end
