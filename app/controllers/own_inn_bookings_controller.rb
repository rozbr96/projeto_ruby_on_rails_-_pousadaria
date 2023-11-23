
class OwnInnBookingsController < ApplicationController
  before_action :authenticate_innkeeper!
  before_action :set_booking, only: [:cancel, :check_in, :check_out, :show]

  def cancel
    if Time.current.ago(2.days) >= @booking.start_date
      @booking.status = :canceled
      @booking.save!

      flash.now[:notice] = 'Reserva cancelada com sucesso'
    else
      @booking.errors.add :start_date, 'deve ser anterior à dois dias atuais'
      flash.now[:alert] = 'Erro ao cancelar a reserva'
    end

    render :show
  end

  def check_in
    @booking.status = :ongoing
    @booking.check_in = DateTime.now
    @booking.save!

    redirect_to own_inn_booking_path(@booking), notice: 'Check in realizado com sucesso'
  end

  def check_out
    @booking.status = :finished
    @booking.check_out = DateTime.now
    @booking.save!

    redirect_to own_inn_booking_path(@booking), notice: 'Check out realizado com sucesso'
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
