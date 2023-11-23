
require 'rails_helper'

describe 'User visits the booking page' do
  before :all do
    @guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper
    room = FactoryBot.create :inn_room, inn: inn
    @booking = FactoryBot.create :booking, guest: @guest,
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

  it 'and does the check out successfully' do
    login_as @innkeeper, scope: :innkeeper

    visit own_inn_booking_path @booking

    click_on 'Realizar check out'

    expect(page).to have_content 'Check out realizado com sucesso'

    within '#booking-info' do
      expect(page).not_to have_content 'Em Andamento'
      expect(page).to have_content 'Finalizada'
    end
  end
end
