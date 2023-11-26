
require 'rails_helper'

describe 'Inns API' do
  context 'GET /api/v1/inns' do
    it 'returns an empty list' do
      get api_v1_inns_path

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.size).to be_zero
    end

    it 'returns active existing inns' do
      first_innkeeper = FactoryBot.create :innkeeper
      second_innkeeper = FactoryBot.create :innkeeper
      third_innkeeper = FactoryBot.create :innkeeper

      first_inn = FactoryBot.create :inn, innkeeper: first_innkeeper, enabled: true
      second_inn = FactoryBot.create :inn, innkeeper: second_innkeeper, enabled: false
      third_inn = FactoryBot.create :inn, innkeeper: third_innkeeper, enabled: true

      get api_v1_inns_path

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.size).to eq 2
      expect(json_response.first['name']).to eq first_inn.name
      expect(json_response.second['name']).to eq third_inn.name
    end

    it 'returns active inns, filtered by their names' do
      first_innkeeper = FactoryBot.create :innkeeper
      second_innkeeper = FactoryBot.create :innkeeper
      third_innkeeper = FactoryBot.create :innkeeper

      first_inn = FactoryBot.create :inn, name: 'Pousada Solar', innkeeper: first_innkeeper, enabled: true
      second_inn = FactoryBot.create :inn, name: 'Pousada do Sol', innkeeper: second_innkeeper, enabled: false
      third_inn = FactoryBot.create :inn, name: 'Pousada Lunar', innkeeper: third_innkeeper, enabled: true

      get api_v1_inns_path params: { search_in_name: 'sol' }

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.size).to eq 1
      expect(json_response.first['name']).to eq 'Pousada Solar'
    end
  end

  context 'GET /api/v1/inns/:id' do
    it 'returns an error due to non existent inn' do
      get '/api/v1/inns/685'

      expect(response).to have_http_status :not_found
    end

    it 'returns the info of the inn with the given id' do
      innkeeper = FactoryBot.create :innkeeper
      inn = FactoryBot.create :inn, innkeeper: innkeeper, enabled: true
      FactoryBot.create :address, inn: inn

      get api_v1_inn_path inn

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response['name']).to eq inn.name
      expect(json_response['address']['city']).to eq inn.address.city
      expect(json_response.keys).not_to include 'registration_number'
      expect(json_response.keys).not_to include 'corporate_name'
    end
  end
end
