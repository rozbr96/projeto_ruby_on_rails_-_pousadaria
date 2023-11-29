
class Host::BillingItemsController < Host::BasicController
  before_action :set_booking, only: [:index]

  def index; end


  private

  def set_booking
    @booking = Booking.find params[:booking_id]
  end
end
