
class Api::V1::InnsController < ::Api::V1::BasicController
  def index
    inns = Inn.where enabled: true

    unless params[:search_in_name].nil?
      inns = inns.where 'name LIKE :term', term: "%#{params[:search_in_name]}%"
    end

    render status: :ok, json: inns
  end
end
