
class OwnInnRoomsController < ApplicationController
  def index
    @rooms = current_innkeeper.inn.inn_rooms
  end
end
