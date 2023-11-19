class AddCodeToBooking < ActiveRecord::Migration[7.1]
  def change
    add_column :bookings, :code, :string, null: false
    add_index :bookings, :code, unique: true
  end
end
