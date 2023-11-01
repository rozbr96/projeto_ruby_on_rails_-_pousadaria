require 'rails_helper'

RSpec.describe Innkeeper, type: :model do
  context '#valid' do
    it 'should fail when name is empty' do
      innkeeper = Innkeeper.new email: 'gui@test.com', password: 'password'

      expect(innkeeper).not_to be_valid
    end
  end
end
