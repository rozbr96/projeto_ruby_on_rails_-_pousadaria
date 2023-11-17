
require 'rails_helper'

describe 'User visits the booking creation page' do
  context 'when logged in as guest' do
    before :all do
      innkeeper = FactoryBot.create :innkeeper
      @guest = FactoryBot.create :guest
      @inn = FactoryBot.create :inn, enabled: true, innkeeper: innkeeper,
        check_in: '10:00', check_out: '12:00'
      @room = FactoryBot.create :inn_room, inn: @inn, enabled: true, price: 100_00,
        maximum_number_of_guests: 3

      ['Dinheiro', 'PIX', 'Cartão'].each do |payment|
        payment_method = PaymentMethod.create! name: payment, enabled: true
        InnPaymentMethod.create! inn: @inn, payment_method: payment_method,
          enabled: true
      end

      FactoryBot.create :address, inn: @inn
      CustomPrice.create! start_date: '2020-01-10', end_date: '2020-01-23',
        price: 150_00, inn_room: @room
    end

    after :all do
      Guest.delete_all
      Address.delete_all
      CustomPrice.delete_all
      InnPaymentMethod.delete_all
      PaymentMethod.delete_all
      InnRoom.delete_all
      Inn.delete_all
      Innkeeper.delete_all
    end

    it 'after verifying the availability of the room' do
      login_as @guest, scope: :guest

      visit root_path

      click_on @inn.name
      click_on @room.name
      click_on 'Verificar Disponibilidade'

      within 'form#booking-verification-form' do
        fill_in 'Data Inicial', with: '2020-01-15'
        fill_in 'Data Final', with: '2020-01-28'
        fill_in 'Número de Convidados', with: '1'
        click_on 'Verificar'
      end

      click_on 'Reservar'

      expect(current_path).to eq new_booking_path

      within 'table' do
        expect(page).to have_content 'Resumo da Reserva'
        expect(page).to have_content 'Data de Entrada'
        expect(page).to have_content '15/01/2020'
        expect(page).to have_content 'Horário de Check in'
        expect(page).to have_content '10:00'
        expect(page).to have_content 'Data de Saída'
        expect(page).to have_content '28/01/2020'
        expect(page).to have_content 'Horário de Check out'
        expect(page).to have_content '12:00'
        expect(page).to have_content 'Pousada'
        expect(page).to have_content @inn.name
        expect(page).to have_content 'Quarto Escolhido'
        expect(page).to have_content @room.name
        expect(page).to have_content 'Valor Total'
        expect(page).to have_content 'R$ 1.850,00'
        expect(page).to have_content 'Meios de Pagamentos'
        expect(page).to have_content 'Dinheiro, PIX e Cartão'
      end
    end

    it 'and finishes the booking in the next page' do
      booking = {
        start_date: '2020-01-15', end_date: '2020-01-28',
        guests_number: 1, inn_room_id: @room.id
      }

      SessionInjecter::inject booking: booking

      login_as @guest, scope: :guest

      visit new_booking_path

      click_on 'Confirmar Reserva'
      expect(current_path).to eq bookings_path
      expect(page).to have_content 'Reserva efetuada com sucesso'
    end

    it 'and goes back to room availability verification page' do
      booking = {
        start_date: '2020-01-15', end_date: '2020-01-28',
        guests_number: 1, inn_room_id: @room.id
      }

      SessionInjecter::inject booking: booking

      login_as @guest

      visit new_booking_path

      click_on 'Voltar'

      expect(current_path).to eq availability_verification_room_path @room
    end
  end

  # TODO add context for not logged users
end
