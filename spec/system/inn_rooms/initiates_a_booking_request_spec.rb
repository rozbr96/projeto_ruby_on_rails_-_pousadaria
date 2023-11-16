
require 'rails_helper'

describe 'User visits the booking room page' do
  before :all do
    innkeeper = FactoryBot.create :innkeeper
    @inn = FactoryBot.create :inn, enabled: true, innkeeper: innkeeper
    FactoryBot.create :address, inn: @inn

    @first_room = FactoryBot.create :inn_room, inn: @inn, enabled: true, price: 100_00,
      maximum_number_of_guests: 3

    @second_room = FactoryBot.create :inn_room, inn: @inn, enabled: true, price: 100_00

    CustomPrice.create! start_date: '2020-01-10', end_date: '2020-01-23',
      price: 150_00, inn_room: @first_room
  end

  after :all do
    Address.delete_all
    CustomPrice.delete_all
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  it 'from the home page' do
    visit root_path

    click_on @inn.name
    click_on @first_room.name
    click_on 'Verificar Disponibilidade'

    expect(current_path).to eq availability_verification_room_path @first_room
  end

  it 'and goes back' do
    visit availability_verification_room_path @first_room

    click_on 'Voltar'

    expect(current_path).to eq room_path @first_room
  end

  it 'and sees the verification form' do
    visit availability_verification_room_path @first_room

    within 'form#booking-verification-form' do
      expect(page).to have_field 'Data Inicial'
      expect(page).to have_field 'Data Final'
      expect(page).to have_field 'Número de Convidados'
    end
  end

  it 'and verifies that the room can be reserved successfully' do
    visit availability_verification_room_path @first_room

    within 'form#booking-verification-form' do
      fill_in 'Data Inicial', with: '2020-01-15'
      fill_in 'Data Final', with: '2020-01-28'
      fill_in 'Número de Convidados', with: '2'
      click_on 'Verificar'
    end

    expect(page).to have_content 'Quarto disponível para o período especificado'
    expect(page).to have_content 'Preço Total Estimado: R$ 1.850,00'
  end

  it 'and verifies the room cannot be reserved, seeing the related errors' do
    visit availability_verification_room_path @first_room

    within 'form#booking-verification-form' do
      fill_in 'Data Inicial', with: '2020-01-15'
      fill_in 'Data Final', with: '2020-01-11'
      fill_in 'Número de Convidados', with: '20'
      click_on 'Verificar'
    end

    expect(page).to have_content 'Impossível reservar esse quarto para o período especificado'
    expect(page).to have_content 'Data Final não pode ser anterior à data inicial'
    expect(page).to have_content 'Número de Convidados excede a quantidade máxima permitida pelo quarto'
  end
end
