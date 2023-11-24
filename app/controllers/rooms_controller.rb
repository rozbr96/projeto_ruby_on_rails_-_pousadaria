
class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :verification, :verify]

  def show; end

  def verification
    @booking = Booking.new
  end

  def verify
    booking_params = params.require(:booking).permit :start_date, :end_date, :guests_number

    @booking = Booking.new booking_params
    @booking.inn_room = @room

    if guest_signed_in?
      @booking.guest = current_guest
    end

    if @booking.valid?
      session[:booking] = @booking
      flash.now[:notice] = 'Quarto disponível para o período especificado'
    else
      flash.now[:alert] = 'Impossível reservar esse quarto para o período especificado'
    end

    render :verification
  end


  private

  def set_room
    @room = InnRoom.find params[:id]
  end
end
