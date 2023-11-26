
class Api::V1::RoomsController < Api::V1::BasicController
  def availability
    room = InnRoom.find params[:room_id]

    booking_params = {
      inn_room: room,
      start_date: params[:start_date],
      end_date: params[:end_date],
      guests_number: params[:guests_number]
    }

    booking = Booking.new booking_params

    if booking.valid?
      status = :ok
      payload = {
        available: true,
        estimated_price: booking.get_estimated_price.to_f / 100
      }
    elsif booking.errors.size == 1 and booking.errors.include? :reservation_dates_range
      status = :ok
      payload = {
        available: false,
        reason: booking.errors.full_messages.first
      }
    else
      status = :bad_request
      payload = { errors: booking.errors.full_messages }
    end

    render status: status, json: payload
  end

  def index
    inn = Inn.find params[:inn_id]
    rooms = inn.inn_rooms.select &:enabled?

    render status: :ok, json: rooms
  end
end
