
class Api::V1::CitiesController < Api::V1::BasicController
  def index
    addresses = Address.joins(:inn).where(inns: { enabled: true })
    cities = addresses.map(&:city).uniq

    render status: :ok, json: cities
  end

  def inns
    city = params[:city]
    inns = Inn.joins(:address).where(enabled: true, addresses: { city: city })

    render status: :ok, json: inns
  end
end
