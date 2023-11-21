class AddDatetimeAttributesToBooking < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :check_in, :datetime
    add_column :bookings, :check_out, :datetime
  end
end
