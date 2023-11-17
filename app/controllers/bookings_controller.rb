
class BookingsController < ApplicationController
  before_action :set_booking, only: [:create, :new]

  def create
    @booking.guest = current_guest

    if @booking.save
      redirect_to bookings_path, notice: 'Reserva efetuada com sucesso'
    else
      flash.now[:alert] = 'Erro ao efetuar reserva'
      render :new
    end
  end

  def index; end

  def new; end


  private

  def set_booking
    # TODO clear session after successful save
    @booking = session[:booking] ? Booking.new(session[:booking]) : nil
  end
end
