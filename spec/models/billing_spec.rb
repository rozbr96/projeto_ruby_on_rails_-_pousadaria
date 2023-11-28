
require 'rails_helper'

RSpec.describe Billing, type: :model do
  before :all do
    guest = FactoryBot.create :guest
    innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: innkeeper,
      check_in: '10:00', check_out: '14:00'
    room = FactoryBot.create :inn_room, inn: inn, price: 100_00
    @booking = FactoryBot.create :booking, inn_room: room, guest: guest,
      start_date: '2020-10-10', end_date: '2020-10-23'
    @payment_method = PaymentMethod.create! name: 'PIX'
  end

  after :all do
    PaymentMethod.delete_all
    Booking.delete_all
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
    Guest.delete_all
  end

  context 'default value' do
    describe '#base_price' do
      it 'should be calculated automatically' do
        allow(Time).to receive(:current).and_return(DateTime.new 2020, 10, 23, 14, 10)

        billing = Billing.new payment_method: @payment_method, booking: @booking

        expect(billing.base_price).to eq 1_500_00
      end
    end

    describe '#finished?' do
      it 'should be false by default' do
        billing = Billing.new payment_method: @payment_method, booking: @booking

        expect(billing.finished).to eq false
      end

      it 'should be false by default' do
        billing = Billing.new payment_method: @payment_method, booking: @booking,
          finished: true

        expect(billing.finished).to eq false
      end
    end
  end

  context 'validity' do
    describe '#valid?' do
      it 'should be invalid when payment method is not set if it is finished' do
        billing = Billing.new booking: @booking
        billing.finished = true

        expect(billing).not_to be_valid
      end
    end
  end
end
