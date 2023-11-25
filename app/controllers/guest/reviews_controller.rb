
class Guest::ReviewsController < Guest::BasicController
  before_action :authenticate_guest!
  before_action :set_booking, only: [:create, :new]

  def create
    @review = Review.new review_params
    @review.booking = @booking

    if @review.save
      redirect_to guest_booking_path(@booking), notice: 'Avaliação registrada com sucesso'
    else
      flash.now[:alert] = 'Erro ao registrar avaliação'
      render :new
    end
  end

  def index
    @reviews = current_guest.reviews
  end

  def new
    @review = Review.new
  end

  def show
    @review = Review.find params[:id]
  end


  private

  def review_params
    params.require(:review).permit :score, :guest_commentary
  end

  def set_booking
    @booking = Booking.find params[:booking_id]
  end
end
