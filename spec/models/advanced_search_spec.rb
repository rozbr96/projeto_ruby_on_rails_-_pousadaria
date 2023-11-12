
require 'rails_helper'

RSpec.describe AdvancedSearch, type: :model do
  describe '#indifferent?' do
    it 'should raise exception for inexistent fields' do
      search = AdvancedSearch.new

      expect {
        search.indifferent? :non_existent_attribute
      }.to raise_error Exception
    end

    it 'should be true for indifferent values' do
      search = AdvancedSearch.new with_pets_allowed: 'indifferent'

      expect(search).to be_indifferent :with_pets_allowed
    end

    it 'should be falsy for other values' do
      search = AdvancedSearch.new with_pets_allowed: 'yes', with_tv: 'no'

      expect(search).not_to be_indifferent :with_tv
      expect(search).not_to be_indifferent :with_pets_allowed
    end
  end

  describe '#range_of' do
    it 'should return nil for empty limit values' do
      search = AdvancedSearch.new least_number_of_bathrooms: '',
        most_number_of_bathrooms: ''

      bathrooms_range = search.range_of :bathrooms

      expect(bathrooms_range).to be_nil
    end

    it 'should return a range with negative infinity as lower range and 10 as upper range' do
      search = AdvancedSearch.new most_number_of_guests: '10'

      guests_range = search.range_of :guests

      expect(guests_range).not_to be_nil
      expect(guests_range.first).to eq -Float::INFINITY
      expect(guests_range.last).to eq 10
    end

    it 'should return a range with 2 as lower range and infinity as upper range' do
      search = AdvancedSearch.new least_number_of_bathrooms: '2'

      bathrooms_range = search.range_of :bathrooms

      expect(bathrooms_range).not_to be_nil
      expect(bathrooms_range.first).to eq 2
      expect(bathrooms_range.last).to eq Float::INFINITY
    end
  end

  describe '#search_in?' do
    it 'should raise exception with an inexistent value' do
      search = AdvancedSearch.new

      expect {
        search.search_in? :name
      }.to raise_error Exception
    end

    it 'should return true indicating a search in the name should be made' do
      search = AdvancedSearch.new search_in_name: '1'

      expect(search.search_in? :name).to eq true
    end

    it 'should return false indicating a search in the name should not be made' do
      search = AdvancedSearch.new search_in_name: '0'

      expect(search.search_in? :name).to eq false
    end
  end

  describe '#with?' do
    it 'should raise exception with an inexistent value' do
      search = AdvancedSearch.new

      expect {
        search.with? :pets_allowed
      }.to raise_error Exception
    end

    it 'should return true indicating inns with tv should be searched for' do
      search = AdvancedSearch.new with_tv: 'yes'

      expect(search.with? :tv).to eq true
    end

    it 'should return false indicating inns without tv should be searched for' do
      search = AdvancedSearch.new with_tv: 'no'

      expect(search.with? :tv).to eq false
    end
  end
end
