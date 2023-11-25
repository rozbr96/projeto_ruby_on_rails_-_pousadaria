
require 'rails_helper'

describe 'User visits the reviews listing page' do
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

  context 'within the innkeeper context' do
    context 'when logged in as innkeeper' do
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

  context 'within the public context' do
    it 'from the home page' do
      visit root_path

      click_on @inn.name
      click_on 'Listar todas avaliações'

      expect(current_path).to eq reviews_inn_path @inn
    end

    it 'and goes back to the inn details page' do
      visit reviews_inn_path @inn

      click_on 'Voltar'

      expect(current_path).to eq inn_path @inn
    end

    it 'and sees no existing reviews' do
      visit reviews_inn_path @inn

      expect(page).to have_content 'Nenhuma avaliação encontrada'
    end

    it 'and sees all existing reviews' do
      texts = ['oldest review', 'old review', 'new review', 'newest review']
      texts.each do |text|
        booking = FactoryBot.create :booking, guest: @guest,
          inn_room: @room, status: Booking.statuses[:finished]

        FactoryBot.create :review, booking: booking, guest_commentary: text
      end

      visit reviews_inn_path @inn

      texts.each do |text|
        expect(page).to have_content text
      end
    end
  end

  context 'within the guest context' do
    context 'when logged in' do
      it 'from the home page' do
        login_as @guest, scope: :guest

        visit root_path

        within 'nav' do
          click_on @guest.name
          click_on 'Minhas Avaliações'
        end

        expect(current_path).to eq guest_reviews_path
      end

      it 'and sees no existing reviews' do
        login_as @guest, scope: :guest

        visit guest_reviews_path

        expect(page).to have_content 'Nenhuma avaliação encontrada'
      end

      it 'and sees existing reviews' do
        review = FactoryBot.create :review, booking: @booking

        login_as @guest, scope: :guest

        visit guest_reviews_path

        expect(page).to have_content review.guest_commentary
      end
    end

    context 'when not logged' do
      it 'should be redirected to the login page' do
        visit guest_reviews_path

        expect(current_path).to eq new_guest_session_path
      end
    end
  end
end
