
require 'rails_helper'

describe 'User visits the inn details page' do
  before :all do
    @guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    @inn = FactoryBot.create :inn, innkeeper: @innkeeper
    @room = FactoryBot.create :inn_room, inn: @inn
    @booking = FactoryBot.create :booking, guest: @guest,
      inn_room: @room, status: Booking.statuses[:finished],
      start_date: Time.now.ago(10.days),
      end_date: Time.now.ago(3.days)

    FactoryBot.create :address, inn: @inn
  end

  after :all do
    Address.delete_all
    Booking.delete_all
    InnRoom.delete_all
    Guest.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  context 'when visiting the private inn details page' do
    context 'when logged in as innkeeper' do
      it 'and sees no existing reviews' do
        login_as @innkeeper, scope: :innkeeper

        visit host_inn_path

        within '#reviews-table' do
          expect(page).to have_content 'Nenhuma avaliação encontrada'
        end
      end

      it 'and sees all existing reviews' do
        ['oldest review', 'old review', 'new review', 'newest review'].each_with_index do |text, index|
          booking = FactoryBot.create :booking, guest: @guest,
            inn_room: @room, status: Booking.statuses[:finished],
            start_date: Time.now.ago((index + 1).months),
            end_date: Time.now.ago(index.months)

          FactoryBot.create :review, booking: booking, guest_commentary: text
        end

        login_as @innkeeper, scope: :innkeeper

        visit host_inn_path

        within '#reviews-table' do
          expect(page).not_to have_content 'Nenhuma avaliação encontrada'

          expect(page).to have_content 'newest review'
          expect(page).to have_content 'new review'
          expect(page).to have_content 'old review'
          expect(page).to have_content 'oldest review'
        end
      end
    end
  end

  context 'when visitng the public inn details page' do
    it 'and sees only the last three reviews' do
      [
        ['oldest review', 2],
        ['old review', 5],
        ['new review', 4],
        ['newest review', 3]
      ].each_with_index do |(text, score), index|
        booking = FactoryBot.create :booking, guest: @guest,
          inn_room: @room, status: Booking.statuses[:finished],
          start_date: Time.now.ago((index + 1).months),
          end_date: Time.now.ago(index.months)

        Review.create! booking: booking, guest_commentary: text, score: score
      end

      login_as @innkeeper, scope: :innkeeper

      visit inn_path @inn

      expect(page).to have_content 'Avaliação Média: 3,50'

      within '#reviews-table' do
        expect(page).not_to have_content 'Nenhuma avaliação encontrada'

        expect(page).to have_content 'newest review'
        expect(page).to have_content 'new review'
        expect(page).to have_content 'old review'
        expect(page).not_to have_content 'oldest review'
      end
    end
  end
end
