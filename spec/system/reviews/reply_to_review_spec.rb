
require 'rails_helper'

describe 'User visits the booking review reply page' do
  before :all do
    guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper
    room = FactoryBot.create :inn_room, inn: inn
    booking = FactoryBot.create :booking, guest: guest,
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

  it 'from the home page' do
    login_as @innkeeper, scope: :innkeeper

    visit root_path

    within 'nav' do
      click_on @innkeeper.name
      click_on 'Avaliações'
    end

    click_on @review.guest_commentary

    expect(current_path).to eq host_inn_review_replying_path @review
    expect(page).to have_content @review.guest_commentary
  end

  it 'and replies successfully' do
    login_as @innkeeper, scope: :innkeeper

    visit host_inn_review_replying_path @review

    fill_in 'Resposta da Pousada', with: 'Esperamos atender às suas expectativas em uma próxima vez'

    click_on 'Responder'

    expect(current_path).to eq host_inn_reviews_path
    expect(page).to have_content 'Avaliação respondida com sucesso'
  end

  it 'and goes back to the reviews listing page' do
    login_as @innkeeper, scope: :innkeeper

    visit host_inn_review_replying_path @review

    click_on 'Voltar'

    expect(current_path).to eq host_inn_reviews_path
  end
end
