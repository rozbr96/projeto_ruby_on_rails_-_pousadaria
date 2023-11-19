
require 'rails_helper'

describe 'User visits the bookings page' do
  context 'when not logged in' do
    it 'and gets redirected to the login page' do
      visit bookings_path

      expect(current_path).to eq new_guest_session_path
    end
  end

  context 'when logged in' do
    before :all do
      @guest = FactoryBot.create :guest
      innkeeper = FactoryBot.create :innkeeper
      inn = FactoryBot.create :inn, innkeeper: innkeeper, check_in: '10:00',
        check_out: '14:00'
      room = FactoryBot.create :inn_room, inn: inn, enabled: true, price: 100_00
      @booking = FactoryBot.create :booking, inn_room: room, guest: @guest,
        guests_number: 1, start_date: '2020-01-10', end_date: '2020-01-23'
      FactoryBot.create :address, inn: inn
    end

    after :all do
      Address.delete_all
      Booking.delete_all
      Guest.delete_all
      InnRoom.delete_all
      Inn.delete_all
      Innkeeper.delete_all
    end

    it 'from the home page' do
      login_as @guest, scope: :guest

      visit root_path

      within 'nav' do
        click_on @guest.name
        click_on 'Minhas Reservas'
      end

      expect(current_path).to eq bookings_path
      expect(page).to have_content 'Minhas Reservas'
    end

    it 'and sees the bookings infos' do
      login_as @guest, scope: :guest

      visit bookings_path

      within '#bookins-table' do
        expect(page).to have_content @booking.code
        expect(page).to have_content '10/01/2020 às 10:00'
        expect(page).to have_content '23/01/2020 às 14:00'
        expect(page).to have_content 'R$ 1.400,00'
      end
    end
  end
end
