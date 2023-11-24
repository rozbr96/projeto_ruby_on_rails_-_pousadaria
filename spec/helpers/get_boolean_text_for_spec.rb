require 'rails_helper'

RSpec.describe GetBooleanTextForHelper, type: :helper do
  it 'should translate successfully' do
    truth_value = get_boolean_text_for true
    falsy_value = get_boolean_text_for false

    expect(truth_value).to eq 'Sim'
    expect(falsy_value).to eq 'Não'
  end
end
