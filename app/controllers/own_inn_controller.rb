
class OwnInnController < ApplicationController
  MAXIMUM_PHONES_AMOUNT = 3

  before_action :authenticate_innkeeper!
  before_action :set_inn, except: [:create, :new]

  def create
    @inn = Inn.new inn_params
    @inn.innkeeper = current_innkeeper

    if @inn.save
      redirect_to own_inn_path, notice: 'Pousada criada com sucesso'
    else
      set_payment_methods_ids
      set_phone_numbers

      flash.now[:alert] = 'Erro ao cadastrar pousada'
      render :new
    end
  end

  def edit
    set_payment_methods_ids
    set_phone_numbers
  end

  def new
    address = Address.new
    @inn = Inn.new address: address

    set_payment_methods_ids
    set_phone_numbers
  end

  def show; end

  def update
    if @inn.update inn_params
      redirect_to own_inn_path, notice: 'Pousada atualizada com sucesso'
    else
      set_payment_methods_ids
      set_phone_numbers

      flash.now[:alert] = 'Erro ao atualizar pousada'
      render :edit
    end
  end


  private

  def inn_params
    address_attributes = :street, :number, :neighbourhood, :city,
      :complement, :state, :postal_code, :inn_id, :id

    phone_numbers_attributes = :number, :city_code, :name, :inn_id, :id

    inn_data = params.require(:inn).permit :name, :corporate_name, :registration_number,
      :description, :pets_are_allowed, :usage_policies, :email, :enabled,
      :check_in, :check_out, address_attributes: address_attributes,
      phone_numbers_attributes: phone_numbers_attributes

    unless params[:payment_methods_ids].nil?
      inn_payment_methods = Hash.new

      unless @inn.nil?
        @inn.inn_payment_methods.each do |inn_payment_method|
          inn_payment_methods.update inn_payment_method.payment_method_id.to_s => {
            id: inn_payment_method.id,
            payment_method_id: inn_payment_method.payment_method.id,
            _destroy: true
          }
        end
      end

      params[:payment_methods_ids].each do |payment_method_id|
        if inn_payment_methods[payment_method_id.to_s].nil?
          inn_payment_methods[payment_method_id.to_s] = {
            payment_method_id: payment_method_id,
            enabled: true
          }
        else
          inn_payment_methods[payment_method_id.to_s][:_destroy] = false
        end
      end

      inn_data[:inn_payment_methods_attributes] = inn_payment_methods
    end

    inn_data
  end

  def set_inn
    @inn = current_innkeeper.inn
  end

  def set_payment_methods_ids
    @payment_methods_ids = @inn.payment_methods.map &:id
  end

  def set_phone_numbers
    @phone_numbers = @inn.phone_numbers.to_a
    (MAXIMUM_PHONES_AMOUNT - @inn.phone_numbers.size).times do
      @phone_numbers << PhoneNumber.new
    end
  end
end
