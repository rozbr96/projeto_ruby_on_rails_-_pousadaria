
class OwnInnController < ApplicationController
  MAXIMUM_PHONES_AMOUNT = 3

  def create
    @inn = Inn.new inn_params
    @inn.innkeeper = current_innkeeper

    if @inn.save
      redirect_to own_inn_path, notice: 'Pousada criada com sucesso'
    else
      (MAXIMUM_PHONES_AMOUNT - @inn.phone_numbers.size).times do
        @inn.phone_numbers << PhoneNumber.new
      end

      flash.now[:alert] = 'Erro ao cadastrar pousada'
      render :new
    end
  end

  def new
    address = Address.new
    phone_numbers = MAXIMUM_PHONES_AMOUNT.times.map { PhoneNumber.new }

    @inn = Inn.new address: address, phone_numbers: phone_numbers
  end

  def show
    @inn = current_innkeeper.inn
  end


  private

  def inn_params
    address_attributes = :street, :number, :neighbourhood, :city,
      :complement, :state, :postal_code

    phone_numbers_attributes = :number, :city_code, :name

    room_data = params.require(:inn).permit :name, :corporate_name, :registration_number,
      :description, :pets_are_allowed, :usage_policies, :email, :enabled,
      :check_in, :check_out, :inn_payment_methods, address_attributes: address_attributes,
      phone_numbers_attributes: phone_numbers_attributes

    unless params[:payment_methods_ids].nil?
      room_data[:inn_payment_methods] = params[:payment_methods_ids].map do |payment_method_id|
        InnPaymentMethod.new payment_method_id: payment_method_id, enabled: true
      end
    end

    room_data
  end
end
