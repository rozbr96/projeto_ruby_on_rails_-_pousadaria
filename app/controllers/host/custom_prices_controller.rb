
class Host::CustomPricesController < Host::BasicController
  before_action :authenticate_innkeeper!
  before_action :set_room
  before_action :verify_room

  def create
    @custom_price = CustomPrice.new custom_price_params
    @custom_price.inn_room = @room

    if @custom_price.save
      redirect_to host_inn_room_path(@room), notice: 'Preço especial adicionado com sucesso'
    else
      flash.now[:alert] = 'Erro ao adicionar preço especial'
      render :new
    end
  end

  def edit
    @custom_price = CustomPrice.find params[:id]
  end

  def new
    @custom_price = CustomPrice.new inn_room: @room
  end

  def update
    @custom_price = CustomPrice.find params[:id]

    if @custom_price.update custom_price_params
      redirect_to host_inn_room_path(@room), notice: 'Preço especial atualizado com sucesso'
    else
      flash.now[:alert] = 'Erro ao atualizar preço especial'
      render :edit
    end
  end

  private

  def custom_price_params
    params.require(:custom_price).permit :start_date, :end_date, :price
  end

  def set_room
    @room = InnRoom.find params[:room_id]
  end

  def verify_room
    return if @room.inn == current_innkeeper.inn

    redirect_to root_path, warning: 'Você não tem permissão para acessar essa página'
  end
end
