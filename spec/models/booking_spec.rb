require 'rails_helper'

RSpec.describe Booking, type: :model do
  before :all do
    innkeeper = FactoryBot.create :innkeeper
    @inn = FactoryBot.create :inn, innkeeper: innkeeper
    @room = FactoryBot.create :inn_room, inn: @inn, enabled: true,
      maximum_number_of_guests: 2
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
          guests_number: 2, status: Booking.statuses[:pending], inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should be invalid when end date is empty' do
        booking = Booking.new start_date: '2020-01-10', end_date: '',
          guests_number: 2, status: Booking.statuses[:pending], inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should be invalid when guests number is empty' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-20',
          guests_number: nil, status: Booking.statuses[:pending], inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should be invalid when roomis empty' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-20',
          guests_number: 2, status: Booking.statuses[:pending], inn_room: nil

        expect(booking).not_to be_valid
      end
    end

    context 'validity of values' do
      it 'should be invalid when start date is after end date' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-09',
          guests_number: 2, status: Booking.statuses[:pending], inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should be invalid when start date is equal to end date' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-10',
          guests_number: 2, status: Booking.statuses[:pending], inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should raise an exception when code length is different than 8' do
        guest = FactoryBot.create :guest


        expect {
          Booking.create! start_date: '2020-01-10', end_date: '2020-01-11',
            guests_number: 2, status: Booking.statuses[:pending], inn_room: @room, code: 'B00K006',
            guest: guest
        }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context 'uniqueness' do
      it 'should be invalid when dates range overlapping occurs for the same room' do
        guest = FactoryBot.create :guest
        Booking.create! start_date: '2020-01-10', end_date: '2020-01-24',
          guests_number: 2, status: Booking.statuses[:reserved], inn_room: @room, guest: guest

        booking = Booking.new start_date: '2020-01-22', end_date: '2020-01-31',
          guests_number: 3, status: Booking.statuses[:pending], inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should be invalid when dates range overlapping occurs for the same user' do
        guest = FactoryBot.create :guest
        another_room = FactoryBot.create :inn_room, inn: @inn, enabled: true,
          maximum_number_of_guests: 2

        Booking.create! start_date: '2020-01-10', end_date: '2020-01-24',
          guests_number: 2, status: Booking.statuses[:reserved],
          inn_room: @room, guest: guest

        booking = Booking.new start_date: '2020-01-22', end_date: '2020-01-31',
          guests_number: 2, status: Booking.statuses[:pending],
          inn_room: another_room, guest: guest

        expect(booking).not_to be_valid
      end

      it 'should be invalid when an existing code is reissued' do
        guest = FactoryBot.create :guest

        Booking.create! start_date: '2020-01-10', end_date: '2020-01-24',
          guests_number: 2, status: Booking.statuses[:ongoing], inn_room: @room, guest: guest,
          code: 'B00K0064'

        allow(SecureRandom).to receive(:alphanumeric).with(8).and_return('B00K0064')
        expect {
          Booking.create! start_date: '2020-02-10', end_date: '2020-02-24',
            guests_number: 2, status: Booking.statuses[:reserved], inn_room: @room, guest: guest
        }.to raise_error ActiveRecord::RecordNotUnique
      end
    end

    context 'numericality' do
      it 'should be invalid when guests number is not positive' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-24',
          guests_number: 0, status: Booking.statuses[:pending], inn_room: @room

        expect(booking).not_to be_valid
      end

      it 'should be invalid when guests number is higher than the max allowed' do
        booking = Booking.new start_date: '2020-01-10', end_date: '2020-01-24',
          guests_number: 3, status: Booking.statuses[:pending], inn_room: @room

        expect(booking).not_to be_valid
      end
    end
  end
end
