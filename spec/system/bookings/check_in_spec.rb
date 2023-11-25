
require 'rails_helper'

describe 'User visits the booking details page' do
  before :all do
    @guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper
    @room = FactoryBot.create :inn_room, inn: inn
  end

  after :all do
    Booking.delete_all
    InnRoom.delete_all
    Guest.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  it 'and makes the check in successfully' do
    booking = FactoryBot.create :booking, guest: @guest,
      inn_room: @room, status: Booking.statuses[:reserved],
      start_date: Time.current.ago(10.minutes)

    login_as @innkeeper, scope: :innkeeper

    visit host_inn_booking_path booking

    click_on 'Registrar check in'

    expect(page).to have_content 'Check in realizado com sucesso'
    expect(page).not_to have_content 'Reservada'
    expect(page).to have_content 'Em Andamento'
  end

  it 'and fails to make the check in, seeing the related error' do
    booking = FactoryBot.create :booking, guest: @guest,
      inn_room: @room, status: Booking.statuses[:reserved],
      start_date: Time.current.advance(days: 1)

    login_as @innkeeper, scope: :innkeeper

    visit host_inn_booking_path booking

    click_on 'Registrar check in'

    expect(page).not_to have_content 'Check in realizado com sucesso'
    expect(page).to have_content 'Erro ao efetuar o check in'
    expect(page).to have_content 'Data Inicial deve ser igual ou posterior à data atual'
  end
end
