class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :street, null: false
      t.integer :number
      t.string :complement
      t.string :neighbourhood, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :postal_code, null: false
      t.references :inn, null: false, foreign_key: true

      t.timestamps
    end
  end
end
