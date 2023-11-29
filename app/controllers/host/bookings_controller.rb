
class Host::BookingsController < Host::BasicController
  before_action :authenticate_innkeeper!
  before_action :set_booking, only: [
    :cancel, :check_in, :checking_out, :check_out, :show
  ]

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
    if Time.current.to_date >= @booking.start_date.to_date
      @booking.status = :ongoing
      @booking.check_in = DateTime.now
      @booking.save!

      billing = Billing.new booking: @booking
      billing.save!

      redirect_to host_inn_booking_path(@booking), notice: 'Check in realizado com sucesso'
    else
      flash.now[:alert] = 'Erro ao efetuar o check in'
      @booking.errors.add :start_date, 'deve ser igual ou posterior à data atual'

      render :show
    end
  end

  def checking_out
    @billing = @booking.billing
    @available_payment_methods = @booking.inn.payment_methods.map do |payment_method|
      [payment_method.name, payment_method.id]
    end
  end

  def check_out
    booking_params = params.require(:booking).permit billing_attributes: :payment_method_id
    billing_params = booking_params[:billing_attributes]
    billing_params[:finished] = true

    @booking.billing.update! billing_params

    @booking.status = :finished
    @booking.check_out = DateTime.now
    @booking.save!

    redirect_to host_inn_booking_path(@booking), notice: 'Check out realizado com sucesso'
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
