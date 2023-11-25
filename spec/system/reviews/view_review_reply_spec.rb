
require 'rails_helper'

describe 'User visit the view review reply page' do
  before :all do
    @guest = FactoryBot.create :guest
    innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: innkeeper
    room = FactoryBot.create :inn_room, inn: inn
    booking = FactoryBot.create :booking, guest: @guest,
      inn_room: room, status: Booking.statuses[:finished],
      start_date: Time.now.ago(10.days),
      end_date: Time.now.ago(3.days)

    FactoryBot.create :address, inn: inn
    @review = Review.create! guest_commentary: 'Bom, mas poderia ser melhor',
      score: 5, booking: booking
  end

  after :all do
    Address.delete_all
    Review.delete_all
    Booking.delete_all
    InnRoom.delete_all
    Guest.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  context 'when logged in' do
    it 'from the home page' do
      login_as @guest, scope: :guest

      visit root_path

      within 'nav' do
        click_on @guest.name
        click_on 'Minhas Avaliações'
      end

      click_on @review.guest_commentary

      expect(current_path).to eq guest_review_path @review
    end

    it 'and sees the reply' do
      login_as @guest, scope: :guest

      visit guest_review_path @review

      expect(page).to have_content @review.guest_commentary
      expect(page).to have_content @review.innkeeper_reply
    end

    it 'and goes back to the reviews listing page' do
      login_as @guest, scope: :guest

      visit guest_review_path @review

      click_on 'Voltar'

      expect(current_path).to eq guest_reviews_path
    end
  end
end
