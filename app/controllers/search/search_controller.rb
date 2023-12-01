
class Search::SearchController < ApplicationController
  def advanced_search
    @inns = Inn.left_outer_joins :address, :inn_rooms
    @inns = @inns.where enabled: true
    @inns = @inns.where({ inn_rooms: { enabled: true } })

    @search = AdvancedSearch.new search_params
    @searched_term = @search.term


    conditions = []
    conditions << 'inns.name LIKE :term' if @search.search_in? :name
    conditions << 'inns.description LIKE :term' if @search.search_in? :description
    conditions << 'addresses.city LIKE :term' if @search.search_in? :city
    conditions << 'addresses.neighbourhood LIKE :term' if @search.search_in? :neighbourhood

    unless conditions.empty?
      sql_string = conditions.join ' OR '
      @inns = @inns.where sql_string, term: "%#{@search.term}%"
    end


    @inns = @inns.where(pets_are_allowed: @search.with?(:pets_allowed)) unless @search.indifferent? :with_pets_allowed

    @inns = @inns.where(inn_rooms: {
      is_accessible_for_people_with_disabilities: @search.with?(:accessibility_for_disabled_people)
    }) unless @search.indifferent? :with_accessibility_for_disabled_people

    @inns = @inns.where(inn_rooms: {
      has_air_conditioning: @search.with?(:air_conditioning)
    }) unless @search.indifferent? :with_air_conditioning

    @inns = @inns.where(inn_rooms: {
      has_tv: @search.with?(:tv)
    }) unless @search.indifferent?(:with_tv)

    @inns = @inns.where(inn_rooms: {
      has_balcony: @search.with?(:balcony)
    }) unless @search.indifferent?(:with_balcony)

    @inns = @inns.where(inn_rooms: {
      has_vault: @search.with?(:vault)
    }) unless @search.indifferent?(:with_vault)


    range_of_guests = @search.range_of :guests
    unless range_of_guests.nil?
      @inns = @inns.where(inn_rooms: {
        maximum_number_of_guests: range_of_guests
      })
    end

    range_of_bathrooms = @search.range_of :bathrooms
    unless range_of_bathrooms.nil?
      @inns = @inns.where(inn_rooms: {
        number_of_bathrooms: range_of_bathrooms
      })
    end

    @inns = @inns.order('LOWER(inns.name)').uniq

    render 'inns/list'
  end

  def search
    @searched_term = params[:term]
    sql_string = 'name LIKE :term OR addresses.city LIKE :term OR addresses.neighbourhood LIKE :term'

    @inns = Inn.joins(:address).where(sql_string, term: "%#{@searched_term}%").order(:name)

    render 'inns/list'
  end

  def search_by_city
    @inns = Inn.where(address: { city: params[:city] }).joins(:address).order(:name)

    render 'inns/list'
  end


  private

  def search_params
    params.require(:advanced_search).permit :term, :with_pets_allowed,
      :with_accessibility_for_disabled_people, :with_air_conditioning,
      :with_tv, :with_balcony, :with_vault, :least_number_of_guests,
      :most_number_of_guests, :least_number_of_bathrooms, :most_number_of_bathrooms,
      :search_in_name, :search_in_description, :search_in_neighbourhood, :search_in_city
  end
end
