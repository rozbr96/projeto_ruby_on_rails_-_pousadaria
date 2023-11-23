require 'rails_helper'

RSpec.describe Review, type: :model do
  before :all do
    guest = FactoryBot.create :guest
    innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: innkeeper
    room = FactoryBot.create :inn_room, inn: inn
    @booking = FactoryBot.create :booking, guest: guest,
      inn_room: room, status: Booking.statuses[:finished],
      start_date: Time.now.ago(10.days),
      end_date: Time.now.ago(3.days)
  end

  after :all do
    Booking.delete_all
    InnRoom.delete_all
    Guest.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  describe '#valid?' do
    context 'numericality' do
      it 'should be invalid when score is out of bounds' do
        review = Review.new booking: @booking, score: 10

        expect(review).not_to be_valid
      end
    end

    context 'presence' do
      it 'should be invalid when score is not given' do
        review = Review.new booking: @booking

        expect(review).not_to be_valid
      end
    end
  end
end
