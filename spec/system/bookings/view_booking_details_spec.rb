
require 'rails_helper'

describe 'User visits the booking details page' do
  before :all do
    @guest = FactoryBot.create :guest
    innkeeper = FactoryBot.create :innkeeper

    @inn = FactoryBot.create :inn, enabled: true, innkeeper: innkeeper,
      check_in: '10:00', check_out: '12:00'

    @room = FactoryBot.create :inn_room, enabled: true, inn: @inn,
      price: 100_00

    @booking = Booking.create! inn_room: @room, status: Booking.statuses[:pending], guest: @guest,
      guests_number: 1, start_date: '2020-01-10', end_date: '2020-01-23'

    FactoryBot.create :address, inn: @inn
  end

  after :all do
    Address.delete_all
    Booking.delete_all
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
    Guest.delete_all
  end

  context 'when logged in as guest' do
    it 'from the home page' do
      login_as @guest, scope: :guest

      visit root_path

      within 'nav' do
        click_on @guest.name
        click_on 'Minhas Reservas'
      end

      within '#bookins-table' do
        click_on @booking.code
      end

      expect(current_path).to eq guest_booking_path @booking
    end

    it 'and goes back to the bookings listing page' do
      login_as @guest, scope: :guest

      visit guest_booking_path @booking

      click_on 'Voltar'

      expect(current_path).to eq guest_bookings_path
    end

    it 'and sees the booking details' do
      login_as @guest, scope: :guest

      visit guest_booking_path @booking

      expect(page).to have_content "Reserva: #{@booking.code}"
      expect(page).to have_content 'Data de Entrada'
      expect(page).to have_content '10/01/2020'
      expect(page).to have_content 'Horário de Check in'
      expect(page).to have_content '10:00'
      expect(page).to have_content 'Data de Saída'
      expect(page).to have_content '23/01/2020'
      expect(page).to have_content 'Horário de Check out'
      expect(page).to have_content '12:00'
      expect(page).to have_content 'Pousada'
      expect(page).to have_content @inn.name
      expect(page).to have_content 'Quarto Escolhido'
      expect(page).to have_content @room.name
      expect(page).to have_content 'Valor Total'
      expect(page).to have_content 'R$ 1.400,00'
    end
  end

  context 'when not logged' do
    it 'and gets redirected to the login page' do
      visit guest_booking_path @booking

      expect(current_path).to eq new_guest_session_path
    end

    it 'after login in' do
      visit guest_booking_path @booking

      within 'form#new_guest' do
        fill_in 'E-mail', with: @guest.email
        fill_in 'Senha', with: @guest.password
        click_on 'Log in'
      end

      expect(current_path).to eq guest_booking_path @booking
    end
  end
end
