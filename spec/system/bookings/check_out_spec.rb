
require 'rails_helper'

describe 'User visits the booking check out page' do
  before :all do
    @guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper, check_in: '10:00'
    room = FactoryBot.create :inn_room, inn: inn, price: 100_00
    @booking = FactoryBot.create :booking, guest: @guest,
      inn_room: room, status: Booking.statuses[:ongoing],
      start_date: Time.current.ago(10.days)

    Billing.create! booking: @booking

    FactoryBot.create :address, inn: inn
    ['Dinheiro', 'PIX', 'Cartão'].each do |payment_method_name|
      payment_method = PaymentMethod.create! name: payment_method_name
      InnPaymentMethod.create! inn: inn, payment_method: payment_method
    end
  end

  after :all do
    Billing.delete_all
    InnPaymentMethod.delete_all
    PaymentMethod.delete_all
    Address.delete_all
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
      click_on 'Em Andamento'
    end

    click_on @booking.code
    click_on 'Realizar check out'

    expect(current_path).to eq check_out_host_inn_booking_path @booking
  end

  it 'and sees the related info about the booking' do
    time = Time.current
    year = time.year
    month = time.month
    day = time.day

    datetime = DateTime.new year, month, day, 9, 30

    BillingItem.create! billing: @booking.billing, amount: 2, unit_price: 10_00,
      description: 'Fanta Laranja 600ml'

    BillingItem.create! billing: @booking.billing, amount: 2, unit_price: 30_00,
      description: 'X-Tudo Duplo'

    allow(Time).to receive(:current).and_return datetime

    login_as @innkeeper, scope: :innkeeper

    visit check_out_host_inn_booking_path @booking

    expect(page).to have_content 'R$ 1.180,00'
  end

  it 'and does the check out successfully' do
    login_as @innkeeper, scope: :innkeeper

    visit check_out_host_inn_booking_path @booking

    select 'PIX', from: 'Meio de Pagamento'

    click_on 'Registrar check out'

    expect(current_path).to eq host_inn_booking_path @booking

    within '#booking-info' do
      expect(page).not_to have_content 'Em Andamento'
      expect(page).to have_content 'Finalizada'
    end
  end
end
