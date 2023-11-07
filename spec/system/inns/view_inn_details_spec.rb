
require 'rails_helper'

describe 'User visits an inn details page' do
  before :all do
    innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'

    address = Address.new street: 'Rua Galática', number: '42', neighbourhood: 'Virgem',
      city: 'Terra', state: 'Via Láctea', postal_code: '01137-000',
      complement: 'Shaka'

    phone_numbers = [
      PhoneNumber.new(city_code: '11', number: '40028922', name: 'Gui'),
      PhoneNumber.new(city_code: '11', number: '49922', name: 'Gui')
    ]

    @inn = Inn.create! name: 'Pousada Solar', corporate_name: 'Pousada Solar LTDA',
      registration_number: '11338082000103', description: 'Pousada universal...',
      pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
      email: 'pousada.universal@test.com', enabled: true, innkeeper: innkeeper,
      check_in: '10:00', check_out: '10:00', address: address, phone_numbers: phone_numbers
  end

  after :all do
    InnPhoneNumber.delete_all
    PhoneNumber.delete_all
    Address.delete_all
    Inn.destroy_all
    Innkeeper.destroy_all
  end

  it 'from the home page' do
    visit root_path

    click_on @inn.name

    expect(current_path).to eq inn_path @inn
  end

  it 'and sees the relevant infos' do
    visit inn_path @inn

    expect(page).to have_content 'Pousada Solar'
    expect(page).to have_content 'Pousada universal...'
    expect(page).to have_content 'Animais são permitidos'
    expect(page).to have_content 'Está estritamente proibido...'
    expect(page).to have_content 'pousada.universal@test.com'
    expect(page).to have_content '10:00'
    expect(page).to have_content '10:00'
    expect(page).to have_content 'Rua Galática, nº 42, Shaka - Virgem, Terra - Via Láctea, 01137-000'
    expect(page).to have_content '(11) 40028922'
    expect(page).to have_content '(11) 49922'
    expect(page).not_to have_content 'Pousada Solar LTDA'
    expect(page).not_to have_content '11338082000103'
  end
end
