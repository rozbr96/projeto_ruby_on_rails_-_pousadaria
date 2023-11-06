
class OwnInnRoomCustomPricesController < ApplicationController
  before_action :authenticate_innkeeper!
  before_action :set_room

  def create
    @custom_price = CustomPrice.new custom_price_params
    @custom_price.inn_room = @room

    if @custom_price.save
      redirect_to own_inn_room_path(@room), notice: 'Preço especial adicionado com sucesso'
    else
      flash.now[:alert] = 'Erro ao adicionar preço especial'
      render :new
    end
  end

  def new
    @custom_price = CustomPrice.new inn_room: @room
  end


  private

  def custom_price_params
    params.require(:custom_price).permit :start_date, :end_date, :price
  end

  def set_room
    @room = InnRoom.find params[:room_id]
  end
end
