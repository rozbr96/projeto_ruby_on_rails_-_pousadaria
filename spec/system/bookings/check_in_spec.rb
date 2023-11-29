
require 'rails_helper'

describe 'User visits the booking check in page' do
  before :all do
    @guest = FactoryBot.create :guest
    @innkeeper = FactoryBot.create :innkeeper
    inn = FactoryBot.create :inn, innkeeper: @innkeeper
    @room = FactoryBot.create :inn_room, inn: inn, maximum_number_of_guests: 4
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

  it 'from the home page' do
    booking = FactoryBot.create :booking, guest: @guest,
      inn_room: @room, status: Booking.statuses[:reserved],
      start_date: Time.current.ago(10.minutes)

    login_as @innkeeper, scope: :innkeeper

    visit root_path

    within 'nav' do
      click_on @innkeeper.name
      click_on 'Todas'
    end

    click_on booking.code
    click_on 'Realizar check in'

    expect(current_path).to eq check_in_host_inn_booking_path booking
  end

  it 'and goes back to the booking details page' do
    booking = FactoryBot.create :booking, guest: @guest,
      inn_room: @room, status: Booking.statuses[:reserved],
      start_date: Time.current.ago(10.minutes)

    login_as @innkeeper, scope: :innkeeper

    visit check_in_host_inn_booking_path booking

    click_on 'Voltar'

    expect(current_path).to eq host_inn_booking_path booking
  end

  it 'and sees the check in form' do
    booking = FactoryBot.create :booking, guest: @guest,
      inn_room: @room, status: Booking.statuses[:reserved],
      start_date: Time.current.ago(10.minutes), guests_number: 3

    login_as @innkeeper, scope: :innkeeper

    visit check_in_host_inn_booking_path booking

    within '#check-in-form' do
      booking.guests_number.times.with_index.each do |index|
        within "#companions-wrapper > .companion-info:nth-child(#{index.succ})" do
          expect(page).to have_field 'Nome'
          expect(page).to have_field 'Tipo de Documento'
          expect(page).to have_field 'Número do Documento'
        end
      end
    end
  end

  it 'and makes the check in successfully' do
    booking = FactoryBot.create :booking, guest: @guest,
      inn_room: @room, status: Booking.statuses[:reserved],
      start_date: Time.current.ago(10.minutes), guests_number: 2

    login_as @innkeeper, scope: :innkeeper

    visit check_in_host_inn_booking_path booking

    within '#check-in-form' do
      within '#companions-wrapper' do
        within '.companion-info:first-child' do
          fill_in 'Nome', with: 'Guilherme'
          select 'CPF', from: 'Tipo de Documento'
          fill_in 'Número do Documento', with: '31732110069'
        end

        within '.companion-info:last-child' do
          fill_in 'Nome', with: 'Giselle'
          select 'CPF', from: 'Tipo de Documento'
          fill_in 'Número do Documento', with: '19946303027'
        end
      end

      click_on 'Registrar check in'
    end

    expect(current_path).to eq host_inn_booking_path booking
    expect(page).to have_content 'Check in realizado com sucesso'
    expect(page).not_to have_content 'Reservada'
    expect(page).to have_content 'Em Andamento'

    within '#companions-table' do
      expect(page).to have_content 'Guilherme'
      expect(page).to have_content 'CPF'
      expect(page).to have_content '31732110069'

      expect(page).to have_content 'Giselle'
      expect(page).to have_content 'CPF'
      expect(page).to have_content '19946303027'
    end
  end

  it 'and fails to make the check in, seeing the related error' do
    booking = FactoryBot.create :booking, guest: @guest,
      inn_room: @room, status: Booking.statuses[:reserved],
      start_date: Time.current.advance(days: 1)

    login_as @innkeeper, scope: :innkeeper

    visit host_inn_booking_path booking

    click_on 'Registrar check in'

    expect(page).not_to have_content 'Check in realizado com sucesso'
    expect(page).to have_content 'Erro ao efetuar o check in'
    expect(page).to have_content 'Data Inicial deve ser igual ou posterior à data atual'
  end
end
