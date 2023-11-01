require 'rails_helper'

RSpec.describe Address, type: :model do
  describe '#valid' do
    before :all do
      innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'
      @inn = Inn.new(
        name: 'Pousada Solar', corporate_name: 'Pousada Solar LTDA',
        registration_number: '11338082000103', description: 'Pousada universal...',
        pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
        email: 'pousada.universal@test.com', enabled: true, innkeeper: innkeeper,
        check_in: '10:00', check_out: '10:00'
      )
    end

    after :all do
      Inn.destroy_all
      Innkeeper.destroy_all
    end

    context 'presence' do
      it 'should fail when street is empty' do
        address = Address.new(
          street: '', number: '42', neighbourhood: 'Virgem',
          city: 'Terra', state: 'Via Láctea', postal_code: '01.137-000',
          complement: 'Shaka', inn: @inn
        )

        expect(address).not_to be_valid
      end

      it 'should fail when neighbourhood is empty' do
        address = Address.new(
          street: 'Rua Galática', number: '42', neighbourhood: '',
          city: 'Terra', state: 'Via Láctea', postal_code: '01.137-000',
          complement: 'Shaka', inn: @inn
        )

        expect(address).not_to be_valid
      end

      it 'should fail when city is empty' do
        address = Address.new(
          street: 'Rua Galática', number: '42', neighbourhood: 'Virgem',
          city: '', state: 'Via Láctea', postal_code: '01.137-000',
          complement: 'Shaka', inn: @inn
        )

        expect(address).not_to be_valid
      end

      it 'should fail when state is empty' do
        address = Address.new(
          street: 'Rua Galática', number: '42', neighbourhood: 'Virgem',
          city: 'Terra', state: '', postal_code: '01.137-000',
          complement: 'Shaka', inn: @inn
        )

        expect(address).not_to be_valid
      end

      it 'should fail when postal_code is empty' do
        address = Address.new(
          street: 'Rua Galática', number: '42', neighbourhood: 'Virgem',
          city: 'Terra', state: 'Via Láctea', postal_code: '',
          complement: 'Shaka', inn: @inn
        )

        expect(address).not_to be_valid
      end

      it 'should fail when inn is empty' do
        address = Address.new(
          street: 'Rua Galática', number: '42', neighbourhood: 'Virgem',
          city: 'Terra', state: 'Via Láctea', postal_code: '01.137-000',
          complement: 'Shaka', inn: nil
        )

        expect(address).not_to be_valid
      end
    end
  end
end
