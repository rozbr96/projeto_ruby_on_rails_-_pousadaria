
class OwnInnController < ApplicationController
  def create
    @inn = Inn.new inn_params
    @inn.innkeeper = current_innkeeper

    if @inn.save
      redirect_to own_inn_path, notice: 'Pousada criada com sucesso'
    else
      flash.now[:alert] = 'Erro ao cadastrar pousada'
      render :new
    end
  end

  def new
    address = Address.new
    @inn = Inn.new address: address
  end

  def show
    @inn = current_innkeeper.inn
  end


  private

  def inn_params
    address_attributes = :street, :number, :neighbourhood, :city,
      :complement, :state, :postal_code

    params.require(:inn).permit :name, :corporate_name, :registration_number,
      :description, :pets_are_allowed, :usage_policies, :email, :enabled,
      :check_in, :check_out, address_attributes: address_attributes
  end
end
