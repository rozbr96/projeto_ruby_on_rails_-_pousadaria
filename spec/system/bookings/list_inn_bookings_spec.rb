
require 'rails_helper'

describe 'User visit the bookings listing page' do
  context 'when logged in as innkeeper' do
    before :all do
      @guest = FactoryBot.create :guest
      @innkeeper = FactoryBot.create :innkeeper
      @inn = FactoryBot.create :inn, innkeeper: @innkeeper, enabled: true,
        check_in: '10:00', check_out: '14:00'
      @room = FactoryBot.create :inn_room, inn: @inn, price: 100_00
      @booking = FactoryBot.create :booking, inn_room: @room, guest: @guest,
          guests_number: 1, start_date: '2020-01-10', end_date: '2020-01-23'
      FactoryBot.create :address, inn: @inn
    end

    after :all do
      Address.delete_all
      Booking.delete_all
      InnRoom.delete_all
      Guest.delete_all
      Inn.delete_all
      Innkeeper.delete_all
    end

    it 'from the home page' do
      login_as @innkeeper, scope: :innkeeper

      visit root_path

      within 'nav' do
        click_on @innkeeper.name
        click_on 'Reservas'
      end

      expect(current_path).to eq host_inn_bookings_path
    end

    it 'and sees the bookings infos' do
      login_as @innkeeper, scope: :innkeeper

      visit host_inn_bookings_path

      within '#bookins-table' do
        expect(page).to have_content @booking.code
        expect(page).to have_content '10/01/2020 às 10:00'
        expect(page).to have_content '23/01/2020 às 14:00'
        expect(page).to have_content 'R$ 1.400,00'
        expect(page).to have_content @room.name

        within 'td:last-child' do
          expect(page).to have_content @booking.guests_number
        end
      end
    end

    it 'and sees only his inn bookings' do
      another_innkeeper = FactoryBot.create :innkeeper
      another_inn = FactoryBot.create :inn, innkeeper: another_innkeeper,
        enabled: true
      another_room = FactoryBot.create :inn_room, inn: another_inn, enabled: true
      another_booking = FactoryBot.create :booking, inn_room: another_room,
        guest: @guest

      login_as @innkeeper, scope: :innkeeper

      visit host_inn_bookings_path

      expect(page).to have_content @booking.code
      expect(page).not_to have_content another_booking.code
    end
  end

  context 'when not logged in' do
    it 'gets directed to the login page' do
      visit host_inn_bookings_path

      expect(current_path).to eq new_innkeeper_session_path
    end

    it 'automatically, after logging in' do
      innkeeper = FactoryBot.create :innkeeper
      FactoryBot.create :inn, innkeeper: innkeeper

      visit host_inn_bookings_path

      within '#new_innkeeper' do
        fill_in 'E-mail', with: innkeeper.email
        fill_in 'Senha', with: innkeeper.password
        click_on 'Log in'
      end

      expect(current_path).to eq host_inn_bookings_path
    end
  end
end
