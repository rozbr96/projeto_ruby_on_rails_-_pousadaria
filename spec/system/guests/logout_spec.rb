
require 'rails_helper'

describe 'User logs out' do
  it 'after opening the application' do
    guest = FactoryBot.create :guest
    
    login_as guest, scope: :guest

    visit inns_path

    within 'nav' do
      click_on guest.name
      click_on 'Sair'
    end

    expect(current_path).to eq root_path
    expect(page).to have_content 'Logout efetuado com sucesso'
  end
end
