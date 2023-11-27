
require 'rails_helper'

describe 'Search API' do
  context 'GET /search' do
    before :all do
      first_innkeeper = FactoryBot.create :innkeeper
      second_innkeeper = FactoryBot.create :innkeeper
      third_innkeeper = FactoryBot.create :innkeeper

      first_inn = FactoryBot.create :inn, innkeeper: first_innkeeper, enabled: true,
        name: 'Primeira Pousada'

      second_inn = FactoryBot.create :inn, innkeeper: second_innkeeper, enabled: false,
        name: 'Segunda Pousada'

      third_inn = FactoryBot.create :inn, innkeeper: third_innkeeper, enabled: true,
        name: 'Terceira Pousada'
    end

    after :all do
      Inn.delete_all
      Innkeeper.delete_all
    end

    it 'should return an empty list' do
      params = { search_for: 'nome estranhamente estranho' }
      get api_v1_search_path params

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.size).to be_zero
    end

    it 'should return only one result' do
      params = { search_for: 'primeira pousada'  }
      get api_v1_search_path params

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'

      json_response = JSON.parse response.body

      expect(json_response.size).to eq 1
      expect(json_response.first['name']).to eq 'Primeira Pousada'
    end
  end
end
