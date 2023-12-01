
require 'rails_helper'

describe 'User visits the room details page' do
  before :all do
    innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, enabled: true, innkeeper: innkeeper
    FactoryBot.create :address, inn: inn

    @room = FactoryBot.create :inn_room, inn: inn, enabled: true, price: 100_00,
      has_balcony: true, has_tv: true, has_air_conditioning: false, has_vault: false,
      is_accessible_for_people_with_disabilities: true
  end

  after :all do
    Address.delete_all
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  it 'from the home page' do
    visit root_path

    click_on @room.inn.name
    click_on @room.name

    expect(current_path).to eq room_path @room
  end

  it 'and goes back to inn page' do
    visit room_path @room

    click_on 'Voltar'

    expect(current_path).to eq inn_path(@room.inn)
  end

  it 'and sees the @room details' do
    visit room_path @room

    expect(page).to have_content @room.name
    expect(page).to have_content @room.description
    expect(page).to have_content "#{@room.dimension} m²"
    expect(page).to have_content 'R$ 100,00'
    expect(page).to have_content 'Possui Varanda'
    expect(page).to have_content 'Possui TV'
    expect(page).to have_content 'Não possui Ar Condicionado'
    expect(page).to have_content 'Não possui Cofre'
    expect(page).to have_content 'É acessível para PcD'
    expect(page).to have_content 'Disponível para reservas'
  end
end
