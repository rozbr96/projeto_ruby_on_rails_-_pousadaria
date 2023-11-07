require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the GetTextForHelper. For example:
#
# describe GetTextForHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe GetTextForHelper, type: :helper do
  it 'should translate successfully' do
    inn = Inn.new pets_are_allowed: true

    text = get_text_for inn, :pets_are_allowed

    expect(text).to eq 'Animais são permitidos'
  end
end
