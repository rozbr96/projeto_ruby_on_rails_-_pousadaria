class CreateBookings < ActiveRecord::Migration[7.1]
  def change
    create_table :bookings do |t|
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :guests_number, null: false
      t.integer :status, null: false, default: 0
      t.references :inn_room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
