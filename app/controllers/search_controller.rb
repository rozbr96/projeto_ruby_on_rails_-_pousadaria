
class SearchController < ApplicationController
  def search_by_city
    @inns = Inn.where(address: { city: params[:city] }).joins(:address).order(:name)

    render 'inns/list'
  end
end
