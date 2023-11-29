require 'rails_helper'

RSpec.describe Companion, type: :model do
  describe '#valid?' do
    before :all do
      guest = FactoryBot.create :guest
      innkeeper = FactoryBot.create :innkeeper
      inn = FactoryBot.create :inn, innkeeper: innkeeper,
        check_in: '10:00', check_out: '14:00'
      room = FactoryBot.create :inn_room, inn: inn, price: 100_00
      @booking = FactoryBot.create :booking, inn_room: room, guest: guest,
        start_date: '2020-10-10', end_date: '2020-10-23'
    end

    after :all do
      Booking.delete_all
      InnRoom.delete_all
      Inn.delete_all
      Innkeeper.delete_all
      Guest.delete_all
    end

    context 'presence' do
      it 'should be invalid when document number is empty' do
        companion = Companion.new booking: @booking, document_type: 'RG',
          document_number: '', name: 'Guilherme'

        expect(companion).not_to be_valid
      end

      it 'should be invalid when document type is empty' do
        companion = Companion.new booking: @booking, document_type: '',
          document_number: '31732110069', name: 'Guilherme'

        expect(companion).not_to be_valid
      end

      it 'should be invalid when name is empty' do
        companion = Companion.new booking: @booking, document_type: 'CPF',
          document_number: '31732110069', name: ''

        expect(companion).not_to be_valid
      end
    end

    context 'uniqueness' do
      it 'should be invalid when when document number is used again within the same booking' do
        first_companion = Companion.create! booking: @booking, document_type: 'CPF',
          document_number: '31732110069', name: 'Guilherme'

        second_companion = Companion.new booking: @booking, document_type: 'CPF',
          document_number: '31732110069', name: 'Giselle'

        expect(second_companion).not_to be_valid
      end
    end
  end
end
