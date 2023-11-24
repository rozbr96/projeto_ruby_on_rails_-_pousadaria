
require 'rails_helper'

describe 'User visits the reviews listing page' do
  before :all do
    @guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper
    room = FactoryBot.create :inn_room, inn: inn
    @booking = FactoryBot.create :booking, guest: @guest,
      inn_room: room, status: Booking.statuses[:finished],
      start_date: Time.now.ago(10.days),
      end_date: Time.now.ago(3.days)

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

  context 'when logged in as innpeer' do
    it 'from the home page' do
      login_as @innkeeper, scope: :innkeeper

      visit root_path

      within 'nav' do
        click_on @innkeeper.name
        click_on 'Avaliações'
      end

      expect(current_path).to eq host_inn_reviews_path
    end

    it 'and sees no existing reviews' do
      login_as @innkeeper, scope: :innkeeper

      visit host_inn_reviews_path

      within '#reviews-table' do
        expect(page).to have_content 'Nenhuma avaliação encontrada'
      end
    end

    it 'and sees the existing reviews' do
      review = Review.create! booking: @booking, score: 5,
        guest_commentary: 'Muitíssimo bom!'

      login_as @innkeeper, scope: :innkeeper

      visit host_inn_reviews_path

      within '#reviews-table' do
        expect(page).not_to have_content 'Nenhuma avaliação encontrada'

        within 'td:nth-child(1)' do
          expect(page).to have_content review.score
        end

        within 'td:nth-child(2)' do
          expect(page).to have_content 'Não'
        end

        within 'td:nth-child(3)' do
          expect(page).to have_content review.guest_commentary
        end
      end
    end
  end

  context 'when not logged' do
    it 'and gets redirected to the login page' do
      visit host_inn_reviews_path

      expect(current_path).to eq new_innkeeper_session_path
    end
  end
end
