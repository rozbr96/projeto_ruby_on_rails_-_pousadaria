
class Api::V1::RoomsController < Api::V1::BasicController
  def index
    inn = Inn.find params[:inn_id]
    rooms = inn.inn_rooms.select &:enabled?

    render status: :ok, json: rooms
  end
end
