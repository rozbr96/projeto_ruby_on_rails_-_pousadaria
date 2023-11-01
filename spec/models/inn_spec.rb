require 'rails_helper'

RSpec.describe Inn, type: :model do
  before :all do
    @first_innkeeper = Innkeeper.create! name: 'Gui', email: 'gui@test.com', password: 'password'
    @second_innkeeper = Innkeeper.create! name: 'Alê', email: 'ale@test.com', password: 'password'
  end

  after :all do
    Innkeeper.delete_all
  end

  describe '#valid?' do
    context 'presence' do
      it 'should fail when name is empty' do
        inn = Inn.new(
          name: '', corporate_name: 'Pousada Universal LTDA',
          registration_number: '11338082000103', description: 'Pousada universal...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: @first_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        expect(inn).not_to be_valid
      end

      it 'should fail when corporate_name is empty' do
        inn = Inn.new(
          name: 'Pousada Universal', corporate_name: '',
          registration_number: '11338082000103', description: 'Pousada universal...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: @second_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        expect(inn).not_to be_valid
      end

      it 'should fail when registration_number is empty' do
        inn = Inn.new(
          name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
          registration_number: '', description: 'Pousada universal...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: @first_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        expect(inn).not_to be_valid
      end

      it 'should fail when description is empty' do
        inn = Inn.new(
          name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
          registration_number: '11338082000103', description: '',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: @second_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        expect(inn).not_to be_valid
      end

      it 'should fail when usage_policies is empty' do
        inn = Inn.new(
          name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
          registration_number: '11338082000103', description: 'Pousada universal...',
          pets_are_allowed: true, usage_policies: '',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: @first_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        expect(inn).not_to be_valid
      end

      it 'should fail when email is empty' do
        inn = Inn.new(
          name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
          registration_number: '11338082000103', description: 'Pousada universal...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: '', enabled: true, innkeeper: @second_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        expect(inn).not_to be_valid
      end

      it 'should fail when innkeeper is empty' do
        inn = Inn.new(
          name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
          registration_number: '11338082000103', description: 'Pousada universal...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: nil,
          check_in: '10:00', check_out: '10:00'
        )

        expect(inn).not_to be_valid
      end

      it 'should fail when check_in is empty' do
        inn = Inn.new(
          name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
          registration_number: '11338082000103', description: 'Pousada universal...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: @second_innkeeper,
          check_in: '', check_out: '10:00'
        )

        expect(inn).not_to be_valid
      end

      it 'should fail when check_out is empty' do
        inn = Inn.new(
          name: 'Pousada Universal', corporate_name: 'Pousada Universal LTDA',
          registration_number: '11338082000103', description: 'Pousada universal...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: @first_innkeeper,
          check_in: '10:00', check_out: ''
        )

        expect(inn).not_to be_valid
      end
    end

    context 'uniqueness' do
      it 'should fail when email is already in use' do
        first_inn = Inn.create!(
          name: 'Fist Inn', corporate_name: 'First Inn LTDA',
          registration_number: '11338082000103', description: 'First Inn...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: @first_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        second_inn = Inn.new(
          name: 'Second Inn', corporate_name: 'Second Inn LTDA',
          registration_number: '70461649000195', description: 'Second Inn...',
          pets_are_allowed: true, usage_policies: 'Fica estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: @second_innkeeper,
          check_in: '12:00', check_out: '12:00'
        )

        expect(second_inn).not_to be_valid
      end

      it 'should fail when registration number is already in use' do
        first_inn = Inn.create!(
          name: 'Fist Inn', corporate_name: 'First Inn LTDA',
          registration_number: '11932464000152', description: 'First Inn...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'first_inn@test.com', enabled: true, innkeeper: @first_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        second_inn = Inn.new(
          name: 'Second Inn', corporate_name: 'Second Inn LTDA',
          registration_number: '11932464000152', description: 'Second Inn...',
          pets_are_allowed: true, usage_policies: 'Fica estritamente proibido...',
          email: 'second_inn@test.com', enabled: true, innkeeper: @innkeeper,
          check_in: '12:00', check_out: '12:00'
        )

        expect(second_inn).not_to be_valid
      end

      it 'should fail when designated innkeeper already owns an inn' do
        first_inn = Inn.create!(
          name: 'Fist Inn', corporate_name: 'First Inn LTDA',
          registration_number: '11932464000152', description: 'First Inn...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'first_inn@test.com', enabled: true, innkeeper: @first_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        second_inn = Inn.new(
          name: 'Second Inn', corporate_name: 'Second Inn LTDA',
          registration_number: '70461649000195', description: 'Second Inn...',
          pets_are_allowed: true, usage_policies: 'Fica estritamente proibido...',
          email: 'second_inn@test.com', enabled: true, innkeeper: @first_innkeeper,
          check_in: '12:00', check_out: '12:00'
        )

        expect(second_inn).not_to be_valid
      end
    end
  end

  describe '#enabled?' do
    context 'default value' do
      it 'should fail if #enabled is not true by default' do
        first_inn = Inn.new(
          name: 'Fist Inn', corporate_name: 'First Inn LTDA',
          registration_number: '11338082000103', description: 'First Inn...',
          pets_are_allowed: true, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: nil, innkeeper: @first_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        expect(first_inn).to be_enabled
      end
    end
  end

  describe '#pets_are_allowed' do
    context 'default value' do
      it 'should fail if #pets_are_allowed is true by default' do
        first_inn = Inn.new(
          name: 'Fist Inn', corporate_name: 'First Inn LTDA',
          registration_number: '11338082000103', description: 'First Inn...',
          pets_are_allowed: nil, usage_policies: 'Está estritamente proibido...',
          email: 'pousada.universal@test.com', enabled: true, innkeeper: @first_innkeeper,
          check_in: '10:00', check_out: '10:00'
        )

        expect(first_inn.pets_are_allowed?).to eq false
      end
    end
  end
end
