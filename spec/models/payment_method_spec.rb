require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  describe '#valid' do
    context 'presence' do
      it 'should fail when name is empty' do
        payment_method = PaymentMethod.new name: '', enabled: false

        expect(payment_method).not_to be_valid
      end
    end

    context 'unique' do
      it 'should fail when name is already in use' do
        PaymentMethod.create! name: 'PIX', enabled: true

        payment_method = PaymentMethod.new name: 'PIX', enabled: false

        expect(payment_method).not_to be_valid
      end
    end
  end
end
