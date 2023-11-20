
class OwnInnBookingsController < ApplicationController
  before_action :authenticate_innkeeper!

  def index
    @bookings = Booking.joins(:inn_room => :inn).where(inn_rooms: {
      inns: {
        innkeeper: current_innkeeper
      }
    })
  end
end
