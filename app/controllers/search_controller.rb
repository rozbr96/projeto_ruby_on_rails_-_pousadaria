
class SearchController < ApplicationController
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
end
