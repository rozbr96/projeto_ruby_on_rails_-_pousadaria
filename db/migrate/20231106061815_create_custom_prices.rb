class CreateCustomPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :custom_prices do |t|
      t.references :inn_room, null: false, foreign_key: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
