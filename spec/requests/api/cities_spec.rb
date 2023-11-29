
require 'rails_helper'

describe 'Cities API' do
  context 'GET /api/v1/cities' do
    it 'should return an empty list' do
      get api_v1_cities_path

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.size).to be_zero
    end

    it 'should return a two elements list' do
      first_innkeeper = FactoryBot.create :innkeeper
      second_innkeeper = FactoryBot.create :innkeeper
      third_innkeeper = FactoryBot.create :innkeeper
      fourth_innkeeper = FactoryBot.create :innkeeper

      first_inn = FactoryBot.create :inn, innkeeper: first_innkeeper, enabled: true
      second_inn = FactoryBot.create :inn, innkeeper: second_innkeeper, enabled: true
      third_inn = FactoryBot.create :inn, innkeeper: third_innkeeper, enabled: false
      fourth_inn = FactoryBot.create :inn, innkeeper: fourth_innkeeper, enabled: true

      FactoryBot.create :address, inn: first_inn, city: 'Cidade A'
      FactoryBot.create :address, inn: second_inn, city: 'Cidade B'
      FactoryBot.create :address, inn: third_inn, city: 'Cidade C'
      FactoryBot.create :address, inn: fourth_inn, city: 'Cidade B'

      get api_v1_cities_path

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.size).to eq 2
      expect(json_response).to include 'Cidade A'
      expect(json_response).to include 'Cidade B'
    end
  end

  context 'GET /api/v1/cities/:city/inns' do
    it 'should return an empty list' do
      first_innkeeper = FactoryBot.create :innkeeper
      second_innkeeper = FactoryBot.create :innkeeper
      third_innkeeper = FactoryBot.create :innkeeper
      fourth_innkeeper = FactoryBot.create :innkeeper

      first_inn = FactoryBot.create :inn, innkeeper: first_innkeeper, enabled: true
      second_inn = FactoryBot.create :inn, innkeeper: second_innkeeper, enabled: true
      third_inn = FactoryBot.create :inn, innkeeper: third_innkeeper, enabled: false
      fourth_inn = FactoryBot.create :inn, innkeeper: fourth_innkeeper, enabled: true

      FactoryBot.create :address, inn: first_inn, city: 'Cidade A'
      FactoryBot.create :address, inn: second_inn, city: 'Cidade B'
      FactoryBot.create :address, inn: third_inn, city: 'Cidade C'
      FactoryBot.create :address, inn: fourth_inn, city: 'Cidade B'

      get api_v1_city_inns_path 'Cidade Z'

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.size).to be_zero
    end

    it 'should return an one elment only list' do
      first_innkeeper = FactoryBot.create :innkeeper
      second_innkeeper = FactoryBot.create :innkeeper
      third_innkeeper = FactoryBot.create :innkeeper
      fourth_innkeeper = FactoryBot.create :innkeeper

      first_inn = FactoryBot.create :inn, innkeeper: first_innkeeper, enabled: true
      second_inn = FactoryBot.create :inn, innkeeper: second_innkeeper, enabled: true
      third_inn = FactoryBot.create :inn, innkeeper: third_innkeeper, enabled: false
      fourth_inn = FactoryBot.create :inn, innkeeper: fourth_innkeeper, enabled: false

      FactoryBot.create :address, inn: first_inn, city: 'Cidade A'
      FactoryBot.create :address, inn: second_inn, city: 'Cidade B'
      FactoryBot.create :address, inn: third_inn, city: 'Cidade C'
      FactoryBot.create :address, inn: fourth_inn, city: 'Cidade B'

      get api_v1_city_inns_path 'Cidade B'

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.size).to eq 1
      expect(json_response.first['name']).to eq second_inn.name
    end
  end
end
