
class InnsController < ApplicationController
  before_action :set_inn, only: [:reviews, :show]

  def index
    inns = Inn.where(enabled: true).order(created_at: :desc).to_a

    @cities = inns.map { |inn| inn.address.city }
    @cities.uniq!
    @cities.sort!

    @newest_inns = inns.shift 3
    @remaining_inns = inns
  end

  def reviews; end

  def show
    @rooms = @inn.inn_rooms.where enabled: true
  end


  private

  def set_inn
    @inn = Inn.find params[:id]
  end
end
