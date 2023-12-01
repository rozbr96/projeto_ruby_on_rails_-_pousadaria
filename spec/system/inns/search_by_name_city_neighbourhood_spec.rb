
require 'rails_helper'

describe 'User searchs for' do
  before :all do
    cities = 'Cidade Alpha XT', 'Cidade Beta', 'Cidade Gamma'
    names = 'Nome Alpha', 'Nome Beta XT', 'Nome Gamma'
    neighbourhoods = 'Bairro Alpha', 'Bairro Beta', 'Bairro Gamma XT'

    cities.zip(names, neighbourhoods).each do |city, name, neighbourhood|
      innkeeper = FactoryBot.create :innkeeper
      inn = FactoryBot.create :inn, name: name, innkeeper: innkeeper, enabled: true
      FactoryBot.create :address, city: city, neighbourhood: neighbourhood, inn: inn
    end
  end

  after :all do
    Address.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  it 'xt and sees the three inns' do
    visit root_path

    within 'nav' do
      fill_in 'search', with: 'xt'

      click_on 'Buscar'
    end

    expect(page).to have_content 'Você procurou por: xt'
    expect(page).to have_content 'Nº de Pousadas encontradas: 3'

    within 'tbody' do
      within 'tr:nth-child(1)' do
        expect(page).to have_content 'Cidade Alpha'
      end

      within 'tr:nth-child(2)' do
        expect(page).to have_content 'Cidade Beta'
      end

      within 'tr:nth-child(3)' do
        expect(page).to have_content 'Cidade Gamma'
      end
    end
  end

  it 'alpha and sees only one inn' do
    visit root_path

    within 'nav' do
      fill_in 'search', with: 'alpha'

      click_on 'Buscar'
    end

    expect(page).to have_content 'Cidade Alpha'
    expect(page).not_to have_content 'Cidade Beta'
    expect(page).not_to have_content 'Cidade Gamma'
  end

  it 'beta and sees only one inn' do
    visit root_path

    within 'nav' do
      fill_in 'search', with: 'beta'

      click_on 'Buscar'
    end

    expect(page).not_to have_content 'Cidade Alpha'
    expect(page).to have_content 'Cidade Beta'
    expect(page).not_to have_content 'Cidade Gamma'
  end

  it 'gamma and sees only one inn' do
    visit root_path

    within 'nav' do
      fill_in 'search', with: 'gamma'

      click_on 'Buscar'
    end

    expect(page).not_to have_content 'Cidade Alpha'
    expect(page).not_to have_content 'Cidade Beta'
    expect(page).to have_content 'Cidade Gamma'
  end

  it 'tangamandápio and sees no matched inn' do
    visit root_path

    within 'nav' do
      fill_in 'search', with: 'tangamandáio'

      click_on 'Buscar'
    end

    expect(page).to have_content 'Você procurou por: tangamandáio'
    expect(page).to have_content 'Nº de Pousadas encontradas: 0'
    expect(page).not_to have_content 'Cidade Alpha'
    expect(page).not_to have_content 'Cidade Beta'
    expect(page).not_to have_content 'Cidade Gamma'
  end
end
