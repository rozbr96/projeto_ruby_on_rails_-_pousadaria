
require 'rails_helper'

describe 'User visits the bookings page' do
  before :all do
    guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper, enabled: true
    room = FactoryBot.create :inn_room, inn: inn, enabled: true
    FactoryBot.create :address, inn: inn

    @pending_booking = FactoryBot.create :booking, status: Booking.statuses[:pending],
      guests_number: 1, inn_room: room, guest: guest, start_date: '2020-08-10',
      end_date: '2020-08-13'

    @reserved_booking = FactoryBot.create :booking, status: Booking.statuses[:reserved],
      guests_number: 1, inn_room: room, guest: guest, start_date: '2020-09-10',
      end_date: '2020-09-13'

    @ongoing_booking = FactoryBot.create :booking, status: Booking.statuses[:ongoing],
      guests_number: 1, inn_room: room, guest: guest, start_date: '2020-07-10',
      end_date: '2020-07-13'
  end

  after :all do
    Address.delete_all
    Booking.delete_all
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
    Guest.delete_all
  end

  context 'looking for active bookings' do
    it 'and sees only the ongoing bookings' do
      login_as @innkeeper, scope: :innkeeper

      visit root_path

      within 'nav' do
        click_on @innkeeper.name
        click_on 'Em Andamento'
      end

      expect(current_path).to eq own_inn_bookings_path
      expect(page).to have_content @ongoing_booking.code
      expect(page).not_to have_content @pending_booking.code
      expect(page).not_to have_content @reserved_booking.code
    end
  end

  context 'with an url with an invalid status' do
    it 'and sees all the bookings' do
      login_as @innkeeper, scope: :innkeeper

      visit own_inn_bookings_path status: :non_existent_status

      expect(page).to have_content @pending_booking.code
      expect(page).to have_content @reserved_booking.code
      expect(page).to have_content @ongoing_booking.code
    end
  end
end
