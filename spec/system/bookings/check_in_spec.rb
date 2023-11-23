
require 'rails_helper'

describe 'User visits the booking details page' do
  before :all do
    guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper
    room = FactoryBot.create :inn_room, inn: inn
    @booking = FactoryBot.create :booking, guest: guest,
      inn_room: room, status: Booking.statuses[:ongoing],
      start_date: Time.now.ago(10.minutes)
  end

  after :all do
    Booking.delete_all
    InnRoom.delete_all
    Guest.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  it 'and makes the check in successfully' do
    login_as @innkeeper, scope: :innkeeper

    visit host_inn_booking_path @booking

    click_on 'Registrar check in'

    expect(page).to have_content 'Check in realizado com sucesso'
    expect(page).not_to have_content 'Reservada'
    expect(page).to have_content 'Em Andamento'
  end
end
