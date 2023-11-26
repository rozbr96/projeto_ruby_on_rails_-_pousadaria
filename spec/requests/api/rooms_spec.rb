
require 'rails_helper'

describe 'Rooms API' do
  context 'GET /api/v1/inns/:inn_id/rooms' do
    before :all do
      innkeeper = FactoryBot.create :innkeeper
      @inn = FactoryBot.create :inn, enabled: true, innkeeper: innkeeper
    end

    after :all do
      Inn.delete_all
      Innkeeper.delete_all
    end

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
end
