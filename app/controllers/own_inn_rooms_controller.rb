
class OwnInnRoomsController < ApplicationController
  before_action :authenticate_innkeeper!

  def create
    @room = InnRoom.new room_params
    @room.inn = current_innkeeper.inn

    if @room.save
      redirect_to own_inn_room_path(@room), notice: 'Quarto registrado com sucesso'
    else
      flash.now[:alert] = 'Erro ao registrar quarto'
      render :new
    end

  end

  def index
    @rooms = current_innkeeper.inn.inn_rooms
  end

  def new
    @room = InnRoom.new
  end

  def show
    @room = InnRoom.find params[:id]
  end

  private

  def room_params
    params.require(:inn_room).permit :name, :description, :maximum_number_of_guests,
      :number_of_bathrooms, :number_of_wardrobes, :has_balcony, :has_air_conditioning,
      :has_tv, :has_vault, :is_accessible_for_people_with_disabilities, :enabled,
      :dimension, :price
  end
end
