
class Guest::ReviewsController < Guest::BasicController
  before_action :set_booking

  def create
    @review = Review.new review_params
    @review.booking = @booking
    @review.save

    redirect_to guest_booking_path(@booking), notice: 'Avaliação registrada com sucesso'
  end

  def new
    @review = Review.new
  end


  private

  def review_params
    params.require(:review).permit :score, :guest_commentary
  end

  def set_booking
    @booking = Booking.find params[:booking_id]
  end
end
