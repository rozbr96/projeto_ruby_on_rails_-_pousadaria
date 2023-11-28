require 'rails_helper'

RSpec.describe BillingItem, type: :model do
  describe '#valid?' do
    before :all do
      guest = FactoryBot.create :guest
      innkeeper = FactoryBot.create :innkeeper
      inn = FactoryBot.create :inn, innkeeper: innkeeper,
        check_in: '10:00', check_out: '14:00'
      room = FactoryBot.create :inn_room, inn: inn, price: 100_00
      booking = FactoryBot.create :booking, inn_room: room, guest: guest,
        start_date: '2020-10-10', end_date: '2020-10-23'
      payment_method = PaymentMethod.create! name: 'PIX'

      @billing = Billing.create! payment_method: payment_method, booking: booking
    end

    after :all do
      Billing.delete_all
      PaymentMethod.delete_all
      Booking.delete_all
      InnRoom.delete_all
      Inn.delete_all
      Innkeeper.delete_all
      Guest.delete_all
    end

    context 'presence' do
      it 'should be invalid when description is empty' do
        item = BillingItem.new billing: @billing, unit_price: 10_00, amount: 1,
          description: ''

        expect(item).not_to be_valid
      end

      it 'should be invalid when amount is empty' do
        item = BillingItem.new billing: @billing, unit_price: 10_00, amount: nil,
          description: 'Fanta Laranja 600ml'

        expect(item).not_to be_valid
      end

      it 'should be invalid when unit_price is empty' do
        item = BillingItem.new billing: @billing, unit_price: nil, amount: 2,
          description: 'Fanta Laranja 600ml'

        expect(item).not_to be_valid
      end
    end

    context 'numericality' do
      it 'should be invalid when amount is not positive' do
        item = BillingItem.new billing: @billing, unit_price: 10_00, amount: 0,
          description: 'Fanta Laranja 600ml'

        expect(item).not_to be_valid
      end

      it 'should be invalid when unit_price is not positive' do
        item = BillingItem.new billing: @billing, unit_price: 0, amount: 2,
          description: 'Fanta Laranja 600ml'

        expect(item).not_to be_valid
      end
    end
  end

  describe 'item_total_price' do
    it 'should calculate the price correctly' do
      first_item = BillingItem.new amount: 2, unit_price: 20_00
      second_item = BillingItem.new amount: 3, unit_price: 23_00

      expect(first_item.total_price).to eq 40_00
      expect(second_item.total_price).to eq 69_00
    end
  end
end
