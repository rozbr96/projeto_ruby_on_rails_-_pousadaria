
require 'rails_helper'

describe 'User vists the booking details page' do
  before :all do
    @guest = FactoryBot.create :guest
    innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: innkeeper, enabled: true
    @room = FactoryBot.create :inn_room, inn: inn
  end

  after :all do
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
    Guest.delete_all
  end

  it 'and cancels the booking successfully' do
    booking = FactoryBot.create :booking, guest: @guest,
      start_date: Time.now.next_week.tomorrow, inn_room: @room

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
      booking = FactoryBot.create :booking, guest: @guest, status: 1,
        start_date: Time.now.yesterday, inn_room: @room

      login_as @guest, scope: :guest

      visit booking_path booking

      click_on 'Cancelar Reserva'

      expect(page).not_to have_content 'Reserva cancelada com sucesso'
      expect(page).to have_content 'Erro ao cancelar reserva'
      expect(page).to have_content 'Status já está em andamento'
    end

    it 'when there is less than seven days before the start' do
      booking = FactoryBot.create :booking, guest: @guest, status: 0,
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
