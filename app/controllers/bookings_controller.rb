
class BookingsController < ApplicationController
  before_action :set_booking, only: [:create, :new, :show]
  before_action :redirect_to_login_page, only: [:create, :index, :show]

  def cancel
    @booking = Booking.find params[:id]

    if @booking.ongoing?
      flash.now[:alert] = 'Erro ao cancelar reserva'
      @booking.errors.add :status, 'já está em andamento'
    elsif Time.current > @booking.start_date.ago(6.days)
      flash.now[:alert] = 'Erro ao cancelar reserva'
      @booking.errors.add :start_date, 'está a 7 dias ou menos de hoje'
    else
      @booking.canceled!
      flash.now[:notice] = 'Reserva cancelada com sucesso'
    end

    render :show
  end

  def create
    @booking.guest = current_guest

    if @booking.save
      redirect_to bookings_path, notice: 'Reserva efetuada com sucesso'
    else
      flash.now[:alert] = 'Erro ao efetuar reserva'
      render :new
    end
  end

  def index
    @bookings = Booking.where guest: current_guest
  end

  def new; end

  def show
    @booking = Booking.find params[:id]
  end

  private

  def redirect_to_login_page
    return if guest_signed_in?

    store_location_for :guest, request.fullpath

    redirect_to new_guest_session_path, alert: 'É necessário estar logado para prosseguir'
  end

  def set_booking
    # TODO clear session after successful save
    @booking = session[:booking] ? Booking.new(session[:booking]) : nil
  end
end
