
require 'rails_helper'

describe 'User visits the billing item addition page' do
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
    click_on 'Adicionar Item'

    expect(current_path).to eq new_host_inn_booking_billing_item_path @booking
  end

  it 'and goes back to the booking billing items listing page' do
    login_as @innkeeper, scope: :innkeeper

    visit new_host_inn_booking_billing_item_path @booking

    click_on 'Voltar'

    expect(current_path).to eq host_inn_booking_billing_items_path @booking
  end

  it 'and sees the creation form' do
    login_as @innkeeper, scope: :innkeeper

    visit new_host_inn_booking_billing_item_path @booking

    within '#new-billing-item-form' do
      expect(page).to have_field 'Descrição'
      expect(page).to have_field 'Quantidade'
      expect(page).to have_field 'Preço Unitário'
    end
  end

  it 'and creates an item successfully' do
    login_as @innkeeper, scope: :innkeeper

    visit new_host_inn_booking_billing_item_path @booking

    within '#new-billing-item-form' do
      fill_in 'Descrição', with: 'Fanta Laranja 600ml'
      fill_in 'Quantidade', with: '2'
      fill_in 'Preço Unitário', with: '1000'

      click_on 'Criar Item Adicional'
    end

    expect(current_path).to eq host_inn_booking_billing_items_path @booking
    expect(page).to have_content 'Item adicionado com sucesso'
    expect(page).to have_content 'Fanta Laranja 600ml'
    expect(page).to have_content 'R$ 10,00'
    expect(page).to have_content 'R$ 20,00'
  end

  it 'and fails to create the item, seeing the related errors' do
    login_as @innkeeper, scope: :innkeeper

    visit new_host_inn_booking_billing_item_path @booking

    within '#new-billing-item-form' do
      fill_in 'Descrição', with: 'Fanta Laranja 600ml'
      fill_in 'Preço Unitário', with: '0'

      click_on 'Criar Item Adicional'
    end

    expect(page).to have_content 'Erro ao adicionar item'
    expect(page).to have_content 'Quantidade não pode ficar em branco'
    expect(page).to have_content 'Preço Unitário deve ser maior que 0'
  end
end
