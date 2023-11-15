require 'rails_helper'

RSpec.describe Booking, type: :model do
  before :all do
    innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: innkeeper
    @room = FactoryBot.create :inn_room, inn: inn, enabled: true
  end

  after :all do
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  describe '#valid?' do
    context 'presence' do
      it 'should be invalid when start date is empty' do
        booking = Booking.new start_date: '', end_date: '2020-01-20',
          guests_number: 2, status: 0, inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should be invalid when end date is empty' do
        booking = Booking.new start_date: '2020-01-10', end_date: '',
          guests_number: 2, status: 0, inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should be invalid when guests number is empty' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-20',
          guests_number: nil, status: 0, inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should be invalid when roomis empty' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-20',
          guests_number: 2, status: 0, inn_room: nil

        expect(booking).not_to be_valid
      end
    end

    context 'validity of values' do
      it 'should be invalid when start date is after end date' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-09',
          guests_number: 2, status: 0, inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should be invalid when start date is equal to end date' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-10',
          guests_number: 2, status: 0, inn_room: @room

        expect(booking).not_to be_valid
      end
    end

    context 'uniqueness' do
      it 'should be invalid when dates range overlapping occurs' do
        Booking.create! start_date: '2020-01-10', end_date: '2020-01-24',
          guests_number: 2, status: 1, inn_room: @room

        booking = Booking.new start_date: '2020-01-22', end_date: '2020-01-31',
          guests_number: 3, status: 0, inn_room: @room

        expect(booking).not_to be_valid
      end
    end

    context 'numericality' do
      it 'should be invalid when guests number is not positive' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-24',
          guests_number: 0, status: 0, inn_room: @room

        expect(booking).not_to be_valid
      end
    end
  end
end
