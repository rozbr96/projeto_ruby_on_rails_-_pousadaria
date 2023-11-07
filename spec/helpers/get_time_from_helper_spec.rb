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
RSpec.describe GetTimeFromHelper, type: :helper do
  it 'should get the time correctly' do
    inn = Inn.new check_in: '10:36'

    time = get_time_from inn.check_in

    expect(time).to eq '10:36'
  end
end
