
require 'rails_helper'

describe 'User visits the the billing items page' do
  before :all do
    guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper,
      check_in: '10:00', check_out: '14:00'
    room = FactoryBot.create :inn_room, inn: inn, price: 100_00
    @booking = FactoryBot.create :booking, inn_room: room, guest: guest,
      start_date: Time.current.ago(2.days), end_date: Time.current.advance(days: 4),
      status: Booking.statuses[:ongoing]
    payment_method = PaymentMethod.create! name: 'PIX'

    @billing = Billing.create! payment_method: payment_method, booking: @booking

    FactoryBot.create :address, inn: inn
  end

  after :all do
    Address.delete_all
    Billing.delete_all
    PaymentMethod.delete_all
    Booking.delete_all
    InnRoom.delete_all
    Inn.delete_all
    Innkeeper.delete_all
    Guest.delete_all
  end

  it 'from the home page' do
    login_as @innkeeper, scope: :innkeeper

    visit root_path

    within 'nav' do
      click_on @innkeeper.name
      click_on 'Em Andamento'
    end

    click_on @booking.code
    click_on 'Itens Adicionais'

    expect(current_path).to eq host_inn_booking_billing_items_path @booking
  end

  it 'and goes back to the booking details page' do
    login_as @innkeeper, scope: :innkeeper

    visit host_inn_booking_billing_items_path @booking

    click_on 'Voltar'

    expect(current_path).to eq host_inn_booking_path @booking
  end

  it 'and sees no existing additional items' do
    login_as @innkeeper, scope: :innkeeper

    visit host_inn_booking_billing_items_path @booking

    within '#additional-items-table' do
      expect(page).to have_content 'Nenhum Item Registrado'
    end
  end

  it 'and sees existing additional items' do
    first_item = BillingItem.create! billing: @billing, amount: 2,
      unit_price: 10_00, description: 'Fanta Laranja 600ml'

    second_item = BillingItem.create! billing: @billing, amount: 2,
      unit_price: 30_00, description: 'X-Tudo Duplo'

    login_as @innkeeper, scope: :innkeeper

    visit host_inn_booking_billing_items_path @booking

    within '#additional-items-table' do
      expect(page).to have_content first_item.description
      expect(page).to have_content second_item.description

      expect(page).to have_content 'R$ 10,00'
      expect(page).to have_content 'R$ 20,00'

      expect(page).to have_content 'R$ 30,00'
      expect(page).to have_content 'R$ 60,00'

      expect(page).to have_content 'R$ 80,00'
    end
  end
end
