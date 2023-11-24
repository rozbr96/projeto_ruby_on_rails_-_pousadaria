
class Host::ReviewsController < Host::BasicController
  def index
    @reviews = Review.joins(:booking => :inn_room).where({
      bookings: {
        inn_rooms: { inn: current_innkeeper.inn }
      }
    })
  end
end
