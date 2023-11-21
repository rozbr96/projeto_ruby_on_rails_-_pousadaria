
class OwnInnBookingsController < ApplicationController
  before_action :authenticate_innkeeper!
  before_action :set_booking, only: [:check_in, :show]

  def check_in
    @booking.status = :ongoing
    @booking.check_in = DateTime.now
    @booking.save!

    redirect_to own_inn_booking_path(@booking), notice: 'Check in realizado com sucesso'
  end

  def index
    @bookings = Booking.joins(:inn_room => :inn).where(inn_rooms: {
      inns: {
        innkeeper: current_innkeeper
      }
    })

    if whitelisted_statuses.include? params[:status]
      @bookings = @bookings.where status: params[:status]
    end
  end

  def show; end


  private

  def set_booking
    @booking = Booking.find params[:id]
  end

  def whitelisted_statuses
    ['ongoing']
  end
end
