require 'rails_helper'

RSpec.describe InnPaymentMethod, type: :model do
  before :all do
    innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'
    @inn = Inn.create! name: 'Fist Inn', corporate_name: 'First Inn LTDA',
        registration_number: '11338082000103', description: 'First Inn...',
        pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
        email: 'pousada.universal@test.com', enabled: true, innkeeper: innkeeper,
        check_in: '10:00', check_out: '10:00'
  end

  after :all do
    Address.delete_all
    Inn.delete_all
    Innkeeper.delete_all
  end

  describe '#valid' do
    context 'presence' do
      it 'should fail when inn is empty' do
        payment_method = PaymentMethod.create! name: 'PIX', enabled: true
        inn_payment_method = InnPaymentMethod.new enabled: true, inn: nil,
          payment_method: payment_method

        expect(inn_payment_method).not_to be_valid
      end

      it 'should fail when payment_method is empty' do
        payment_method = PaymentMethod.create! name: 'PIX', enabled: true
        inn_payment_method = InnPaymentMethod.new enabled: true, inn: @inn,
          payment_method: nil

        expect(inn_payment_method).not_to be_valid
      end
    end

    context 'unique' do
      it 'should fail when payment and method are already in use' do
        payment_method = PaymentMethod.create! name: 'PIX', enabled: true

        first_inn_payment_method = InnPaymentMethod.create! enabled: true, inn: @inn,
          payment_method: payment_method

        second_inn_payment_method = InnPaymentMethod.new enabled: false, inn: @inn,
          payment_method: payment_method

        expect(second_inn_payment_method).not_to be_valid
      end
    end
  end
end
