class AddEstimatedPriceToBooking < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :estimated_price, :integer
  end
end
