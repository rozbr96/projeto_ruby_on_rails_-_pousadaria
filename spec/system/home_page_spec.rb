
require 'rails_helper'

describe 'User visits home page' do
  it 'and is ensured to be on the correct page' do
    visit root_path

    expect(page).to have_content 'Pousadaria'
  end
end
