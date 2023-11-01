
require 'rails_helper'

describe 'User visits inns listing page' do
  context 'with no existing inns' do
    it 'and sees no existing inns' do
      visit root_path

      within 'nav' do
        click_on 'Pousadas'
      end

      expect(page).to have_content 'Nenhuma pousada disponível'
    end
  end

  context 'with existing inns' do
    it 'and sees existing inns' do
      innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'
      inn = Inn.create!(
        name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
        registration_number: '11338082000103', description: 'Pousada universal...',
        pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
        email: 'pousada.universal@test.com', enabled: true, innkeeper: innkeeper,
        check_in: '10:00', check_out: '10:00'
      )

      visit root_path

      within 'nav' do
        click_on 'Pousadas'
      end

      expect(current_path).to eq inns_path
      expect(page).to have_content inn.name
      expect(page).to have_content inn.description
    end

    it 'and sees no available inns' do
      innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'
      inn = Inn.create!(
        name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
        registration_number: '11338082000103', description: 'Pousada universal...',
        pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
        email: 'pousada.universal@test.com', enabled: false, innkeeper: innkeeper,
        check_in: '10:00', check_out: '10:00'
      )

      visit root_path

      within 'nav' do
        click_on 'Pousadas'
      end

      expect(page).to have_content 'Nenhuma pousada disponível'
    end
  end
end
