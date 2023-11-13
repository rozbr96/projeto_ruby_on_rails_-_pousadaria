
require 'rails_helper'

describe 'User visits an inn details page' do
  it 'and sees the avaible rooms' do
    innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: innkeeper, enabled: true
    FactoryBot.create :address, inn: inn

    [true, true, false].each do |enabled|
      FactoryBot.create :inn_room, inn: inn, enabled: enabled
    end

    visit root_path

    click_on inn.name

    expect(current_path).to eq inn_path inn
    expect(page).to have_content 'Quartos Disponíveis'
    expect(page).to have_content InnRoom.first.name
    expect(page).not_to have_content InnRoom.last.name
  end

  it 'and sees no available rooms' do
    innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: innkeeper, enabled: true
    FactoryBot.create :address, inn: inn

    [false, false].each do |enabled|
      FactoryBot.create :inn_room, inn: inn, enabled: enabled
    end

    visit root_path

    click_on inn.name

    expect(current_path).to eq inn_path inn
    expect(page).to have_content 'Quartos Disponíveis'
    expect(page).to have_content 'Nenhum quarto encontrado'
    expect(page).not_to have_content InnRoom.first.name
    expect(page).not_to have_content InnRoom.last.name
  end
end
