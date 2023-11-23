
require 'rails_helper'

describe 'User visits the review creation page' do
  before :all do
    @guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper
    room = FactoryBot.create :inn_room, inn: inn
    @booking = FactoryBot.create :booking, guest: @guest,
      inn_room: room, status: Booking.statuses[:finished],
      start_date: Time.now.ago(10.minutes)

    FactoryBot.create :address, inn: inn
  end

  after :all do
    Address.delete_all
    Booking.delete_all
    InnRoom.delete_all
    Guest.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  context 'when logged in as guest' do
    it 'from the home page' do
      login_as @guest, scope: :guest

      visit root_path

      within 'nav' do
        click_on @guest.name
        click_on 'Minhas Reservas'
      end

      click_on @booking.code
      click_on 'Registrar Avaliação'

      expect(current_path).to eq new_booking_review_path @booking
    end

    it 'and goes back to the booking details page' do
      login_as @guest, scope: :guest

      visit new_booking_review_path @booking

      click_on 'Voltar'

      expect(current_path).to eq booking_path @booking
    end

    it 'and sees the review form' do
      login_as @guest, scope: :guest

      visit new_booking_review_path @booking

      within '#booking-review' do
        expect(page).to have_field 'Nota'
        expect(page).to have_field 'Comentário'
      end
    end

    it 'and creates the review successfully' do
      login_as @guest, scope: :guest

      visit new_booking_review_path @booking

      within '#booking-review' do
        fill_in 'Nota', with: '4'
        fill_in 'Comentário', with: 'Muito bom!!!'
        click_on 'Avaliar'
      end

      expect(current_path).to eq booking_path @booking
      expect(page).to have_content 'Avaliação registrada com sucesso'
      expect(page).to have_content 'Muito bom!!!'
    end
  end
end
