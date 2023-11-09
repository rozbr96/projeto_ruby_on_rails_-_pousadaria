
require 'rails_helper'

describe 'User opens the quick search menu' do
  before :all do
    cities = 'Cidade B', 'Cidade A', 'Cidade C', 'Cidade B'
    names = 'Pousada 04', 'Pousada 03', 'Pousada 02', 'Pousada 01'

    cities.zip(names) do |city, name|
      innkeeper = FactoryBot.create :innkeeper
      inn = FactoryBot.create :inn, innkeeper: innkeeper, name: name, enabled: true
      FactoryBot.create :address, inn: inn, city: city
    end
  end

  after :all do
    Address.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  it 'and sees the available cities for searching' do
    visit root_path

    click_on 'Busca rápida'

    within '#cities-list' do
      expect(page).to have_content 'Cidade A'
      expect(page).to have_content 'Cidade B'
      expect(page).to have_content 'Cidade C'
    end
  end

  it 'selects a city and sees only the inns from that city' do
    visit root_path

    click_on 'Busca rápida'

    within '#cities-list' do
      click_on 'Cidade B'
    end

    expect(current_path).to eq search_by_city_path 'Cidade B'

    within '#inns tbody' do
      expect(page).not_to have_content 'Pousada 02'
      expect(page).not_to have_content 'Pousada 03'

      within 'tr:nth-child(1)' do
        expect(page).to have_content 'Pousada 01'
      end

      within 'tr:nth-child(2)' do
        expect(page).to have_content 'Pousada 04'
      end
    end
  end
end
