
require 'rails_helper'

describe 'Rooms API' do
  before :all do
    innkeeper = FactoryBot.create :innkeeper
    @inn = FactoryBot.create :inn, enabled: true, innkeeper: innkeeper
  end

  after :all do
    Inn.delete_all
    Innkeeper.delete_all
  end

  context 'GET /api/v1/inns/:inn_id/rooms' do
    it 'returns an empty list' do
      get api_v1_inn_rooms_path @inn

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response).to be_empty
    end

    it 'returns an list with existing rooms' do
      first_room = FactoryBot.create :inn_room, inn: @inn, enabled: true
      second_room = FactoryBot.create :inn_room, inn: @inn, enabled: true
      third_room = FactoryBot.create :inn_room, inn: @inn, enabled: false
      fourth_room = FactoryBot.create :inn_room, inn: @inn, enabled: true

      get api_v1_inn_rooms_path @inn

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.size).to eq 3
      expect(json_response.first['name']).to eq first_room.name
      expect(json_response.second['name']).to eq second_room.name
      expect(json_response.third['name']).to eq fourth_room.name
    end

    it 'returns an error due to a non existent inn' do
      get '/api/v1/inns/685/rooms'

      expect(response).to have_http_status :not_found
    end
  end

  context 'GET /api/v1/rooms/:room_id/availability' do
    before :all do
      guest = FactoryBot.create :guest
      @room = FactoryBot.create :inn_room, enabled: true, inn: @inn,
      maximum_number_of_guests: 2, price: 110_50

      CustomPrice.create! start_date: '2020-02-07', end_date: '2020-02-20',
        price: 150_00, inn_room: @room

      [
        {
          start_date: '2020-02-01', end_date: '2020-02-14',
          guests_number: 2, inn_room: @room, guest: guest,
          status: Booking.statuses[:reserved]
        },
        {
          start_date: '2020-02-15', end_date: '2020-02-25',
          guests_number: 2, inn_room: @room, guest: guest,
          status: Booking.statuses[:reserved]
        }
      ].each { |booking_params| Booking.create! booking_params }
    end

    after :all do
      CustomPrice.delete_all
      Booking.delete_all
      InnRoom.delete_all
      Guest.delete_all
    end

    it 'checks the room availability successfully (with availability)' do
      get api_v1_room_availability_path @room, params: {
        start_date: '2020-01-09', end_date: '2020-01-23', guests_number: 2
      }

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response['available']).to eq true
      expect(json_response['estimated_price']).to eq 1_657.50
    end

    it 'checks the room availability successfully (with no availability)' do
      get api_v1_room_availability_path @room, params: {
        start_date: '2020-02-10', end_date: '2020-02-20', guests_number: 2
      }

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response['available']).to eq false
      expect(json_response.keys).not_to include 'estimated_price'
      expect(json_response['reason']).to eq 'Período de reserva está sobrepondo algum outro período já existente (talvez em outro quarto)'
    end

    it 'fails to check the room availability' do
      get api_v1_room_availability_path @room, params: {
        start_date: '2020-01-10', end_date: '2020-01-10', guests_number: 4
      }

      expect(response).to have_http_status :bad_request
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response['errors'].size).to eq 2
      expect(json_response['errors']).to include 'Data Final não pode ser igual à data inicial'
      expect(json_response['errors']).to include 'Número de Convidados excede a quantidade máxima permitida pelo quarto'
    end

    it 'fails due to an inexistent room' do
      get '/api/v1/rooms/inexistent_id/availability'

      expect(response).to have_http_status :not_found
    end
  end
end
