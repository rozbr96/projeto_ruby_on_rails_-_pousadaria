
require 'rails_helper'

describe 'User vists the booking details page' do
  before :all do
    @guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper, enabled: true
    @room = FactoryBot.create :inn_room, inn: inn
    FactoryBot.create :address, inn: inn
  end

  after :all do
    Address.delete_all
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
    Guest.delete_all
  end

  context 'when logged in as guest' do
    it 'and cancels the booking successfully' do
      booking = FactoryBot.create :booking, guest: @guest,
        start_date: Time.current.advance(days: 7), inn_room: @room

      login_as @guest, scope: :guest

      visit booking_path booking

      click_on 'Cancelar Reserva'

      expect(page).to have_content 'Reserva cancelada com sucesso'

      within '#booking-info' do
        expect(page).to have_content 'Cancelada'
      end
    end

    context 'fails to cancel the booking, seeing the related error' do
      it 'when it is already on going' do
        booking = FactoryBot.create :booking, guest: @guest,
          status: Booking.statuses[:ongoing],
          start_date: Time.now.yesterday, inn_room: @room

        login_as @guest, scope: :guest

        visit booking_path booking

        click_on 'Cancelar Reserva'

        expect(page).not_to have_content 'Reserva cancelada com sucesso'
        expect(page).to have_content 'Erro ao cancelar reserva'
        expect(page).to have_content 'Status já está em andamento'
      end

      it 'when there is less than seven days before the start' do
        booking = FactoryBot.create :booking, guest: @guest,
          status: Booking.statuses[:reserved],
          start_date: Time.now.advance(days: 6), inn_room: @room

        login_as @guest, scope: :guest

        visit booking_path booking

        click_on 'Cancelar Reserva'

        expect(page).not_to have_content 'Reserva cancelada com sucesso'
        expect(page).to have_content 'Erro ao cancelar reserva'
        expect(page).to have_content 'Data Inicial está a 7 dias ou menos de hoje'
      end
    end
  end

  context 'when logged in as innkeeper' do
    it 'from the home page' do
      booking = Booking.create! status: Booking.statuses[:reserved],
        start_date: Time.current.ago(7.days), guest: @guest,
        end_date: Time.current.advance(days: 5), inn_room: @room,
        guests_number: 1

      login_as @innkeeper, scope: :innkeeper

      visit root_path

      within 'nav' do
        click_on @innkeeper.name
        click_on 'Reservas'
      end

      click_on booking.code

      expect(current_path).to eq own_inn_booking_path booking
    end

    it 'and cancels the booking successfully' do
      booking = Booking.create! status: Booking.statuses[:reserved],
        start_date: Time.current.ago(2.days), guest: @guest,
        end_date: Time.current.advance(days: 5), inn_room: @room,
        guests_number: 1

      login_as @innkeeper, scope: :innkeeper

      visit own_inn_booking_path booking

      click_on 'Cancelar Reserva'

      expect(page).to have_content 'Reserva cancelada com sucesso'
    end

    it 'and fails to cancel the booking' do
      booking = Booking.create! status: Booking.statuses[:reserved],
        start_date: Time.current.yesterday, guest: @guest,
        end_date: Time.current.advance(days: 5), inn_room: @room,
        guests_number: 1

      login_as @innkeeper, scope: :innkeeper

      visit own_inn_booking_path booking

      click_on 'Cancelar Reserva'

      expect(page).not_to have_content 'Reserva cancelada com sucesso'
      expect(page).to have_content 'Erro ao cancelar a reserva'
      expect(page).to have_content 'Data Inicial deve ser anterior à dois dias atuais'
    end
  end
end
