
class Api::V1::SearchController < Api::V1::BasicController
  def search
    inns = Inn.where(enabled: true).where('name LIKE :term', term: "%#{params[:search_for]}%").order('LOWER(name)')

    inns_json = inns.as_json include: :address, methods: :score_avg

    render :ok, json: inns_json
  end
end
