
require 'rails_helper'

describe 'User opens the advanced search menu' do
  before :all do
    first_innkeeper = FactoryBot.create :innkeeper
    second_innkeeper = FactoryBot.create :innkeeper
    third_innkeeper = FactoryBot.create :innkeeper
    fourth_innkeeper = FactoryBot.create :innkeeper
    fifth_innkeeper = FactoryBot.create :innkeeper

    first_inn = FactoryBot.create :inn, innkeeper: first_innkeeper, name: 'Pousada Solar', description: '...de frente para o mar...', pets_are_allowed: true, enabled: true
    second_inn = FactoryBot.create :inn, innkeeper: second_innkeeper, name: 'Pousada do Sol', description: '...aproveite o sol...', pets_are_allowed: false, enabled: false
    third_inn = FactoryBot.create :inn, innkeeper: third_innkeeper, name: 'Galáxia Infinita', description: '...quartos arejados...', pets_are_allowed: false, enabled: true
    fourth_inn = FactoryBot.create :inn, innkeeper: fourth_innkeeper, name: 'Pousada Galáctica', description: '-', pets_are_allowed: true, enabled: true
    fifth_inn = FactoryBot.create :inn, innkeeper: fifth_innkeeper, name: 'Galaxy Explosion', description: '...ambientes aromatizados...', pets_are_allowed: true, enabled: true

    FactoryBot.create :inn_room, inn: first_inn, enabled: true, is_accessible_for_people_with_disabilities: true, has_air_conditioning: true, has_tv: true
    FactoryBot.create :inn_room, inn: second_inn, enabled: false, is_accessible_for_people_with_disabilities: true, has_air_conditioning: true, has_tv: true
    FactoryBot.create :inn_room, inn: third_inn, enabled: true, is_accessible_for_people_with_disabilities: true, has_air_conditioning: false, has_tv: true
    FactoryBot.create :inn_room, inn: fourth_inn, enabled: true, is_accessible_for_people_with_disabilities: false, has_air_conditioning: false, has_tv: false
    FactoryBot.create :inn_room, inn: fifth_inn, enabled: true, is_accessible_for_people_with_disabilities: true, has_air_conditioning: true, has_tv: true
    FactoryBot.create :inn_room, inn: first_inn, enabled: true, is_accessible_for_people_with_disabilities: true, has_air_conditioning: false, has_tv: false

    FactoryBot.create :address, inn: first_inn, city: 'Mercúrio', neighbourhood: 'Sol'
    FactoryBot.create :address, inn: second_inn, city: 'Vênus', neighbourhood: 'Terra'
    FactoryBot.create :address, inn: third_inn, city: 'Terra', neighbourhood: 'Lua'
    FactoryBot.create :address, inn: fourth_inn, city: 'Marte', neighbourhood: 'Vermelhidão'
    FactoryBot.create :address, inn: fifth_inn, city: 'Júpiter', neighbourhood: 'Galática'
  end

  after :all do
    Address.delete_all
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  it 'and sees the advanced search form' do
    visit root_path

    within 'nav' do
      click_on 'Busca Avançada'
    end

    within '#advanced-search-wrapper' do
      expect(page).to have_field 'Buscar por...'
      expect(page).to have_field 'Nome'
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Bairro'
      expect(page).to have_field 'Cidade'
      expect(page).to have_field 'with_pets_allowed_no'
      expect(page).to have_field 'with_pets_allowed_indifferent'
      expect(page).to have_field 'with_pets_allowed_yes'
      expect(page).to have_field 'with_accessibility_for_disabled_people_no'
      expect(page).to have_field 'with_accessibility_for_disabled_people_indifferent'
      expect(page).to have_field 'with_accessibility_for_disabled_people_yes'
      expect(page).to have_field 'with_air_conditioning_no'
      expect(page).to have_field 'with_air_conditioning_indifferent'
      expect(page).to have_field 'with_air_conditioning_yes'
      expect(page).to have_field 'with_tv_no'
      expect(page).to have_field 'with_tv_indifferent'
      expect(page).to have_field 'with_tv_yes'
      expect(page).to have_field 'with_balcony_no'
      expect(page).to have_field 'with_balcony_indifferent'
      expect(page).to have_field 'with_balcony_yes'
      expect(page).to have_field 'with_vault_no'
      expect(page).to have_field 'with_vault_indifferent'
      expect(page).to have_field 'with_vault_yes'
      expect(page).to have_field 'advanced_search_least_number_of_guests'
      expect(page).to have_field 'advanced_search_most_number_of_guests'
      expect(page).to have_field 'advanced_search_least_number_of_bathrooms'
      expect(page).to have_field 'advanced_search_most_number_of_bathrooms'
    end
  end

  it 'searches and sees all active inns with active rooms' do
    visit root_path

    within 'nav' do
      click_on 'Busca Avançada'
    end

    within '#advanced-search-wrapper' do
      click_on 'Criar Busca Avançada'
    end

    expect(current_path).to eq search_advanced_path
    expect(page).to have_content 'Nº de Pousadas encontradas: 4'
  end

  it 'searches for "mar" in name and sees no results' do
    visit root_path

    within 'nav' do
      click_on 'Busca Avançada'
    end

    within '#advanced-search-wrapper' do
      fill_in 'Buscar por...', with: 'mar'
      check 'Nome'
      click_on 'Criar Busca Avançada'
    end

    expect(current_path).to eq search_advanced_path
    expect(page).to have_content 'Nº de Pousadas encontradas: 0'
    expect(page).to have_content 'Nenhuma pousada disponível'
  end

  it 'serches for "sol" in name and description and sees only one result' do
    visit root_path

    within 'nav' do
      click_on 'Busca Avançada'
    end

    within '#advanced-search-wrapper' do
      fill_in 'Buscar por...', with: 'sol'
      check 'Nome'
      check 'Descrição'
      click_on 'Criar Busca Avançada'
    end

    expect(current_path).to eq search_advanced_path
    expect(page).to have_content 'Nº de Pousadas encontradas: 1'
    expect(page).to have_content 'Pousada Solar'
  end

  it 'searches for rooms with accessibility for disabled people and sees three results' do
    visit root_path

    within 'nav' do
      click_on 'Busca Avançada'
    end

    within '#advanced-search-wrapper' do
      fill_in 'Buscar por...', with: 'sol'
      choose 'with_accessibility_for_disabled_people_yes'
      click_on 'Criar Busca Avançada'
    end

    expect(current_path).to eq search_advanced_path
    expect(page).to have_content 'Nº de Pousadas encontradas: 3'
    expect(page).to have_content 'Pousada Solar'
    expect(page).to have_content 'Galáxia Infinita'
    expect(page).to have_content 'Galaxy Explosion'
  end

  it 'searches for rooms with tv and air conditioning and sees only one result' do
    visit root_path

    within 'nav' do
      click_on 'Busca Avançada'
    end

    within '#advanced-search-wrapper' do
      choose 'with_tv_yes'
      choose 'with_air_conditioning_yes'
      click_on 'Criar Busca Avançada'
    end

    expect(current_path).to eq search_advanced_path
    expect(page).to have_content 'Nº de Pousadas encontradas: 2'
    expect(page).to have_content 'Pousada Solar'
    expect(page).to have_content 'Galaxy Explosion'
  end
end
