
class Host::BillingItemsController < Host::BasicController
  before_action :set_booking, only: [:create, :index, :new]

  def create
    billing_item_params = params.require(:billing_item).permit :amount,
      :unit_price, :description

    billing_item_params[:billing] = @booking.billing

    @billing_item = BillingItem.new billing_item_params

    if @billing_item.save
      flash[:notice] = 'Item adicionado com sucesso'
      redirect_to host_inn_booking_billing_items_path @booking
    else
      flash.now[:alert] = 'Erro ao adicionar item'
      render :new
    end
  end

  def index; end

  def new
    @billing_item = BillingItem.new
  end


  private

  def set_booking
    @booking = Booking.find params[:booking_id]
  end
end
