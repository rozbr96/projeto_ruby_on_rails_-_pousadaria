
require 'rails_helper'

describe 'User opens the advanced search menu' do
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

  xit 'and searches...' do; end
end
