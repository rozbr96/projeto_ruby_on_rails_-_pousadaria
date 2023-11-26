
class Api::V1::InnsController < ::Api::V1::BasicController
  def index
    inns = Inn.where enabled: true

    unless params[:search_in_name].nil?
      inns = inns.where 'name LIKE :term', term: "%#{params[:search_in_name]}%"
    end

    render status: :ok, json: inns
  end

  def show
    inn = Inn.find params[:id]
    inn_json = inn.as_json include: :address, methods: :score_avg

    inn_json.extract! 'registration_number', 'corporate_name'

    render status: :ok, json: inn_json
  end
end
