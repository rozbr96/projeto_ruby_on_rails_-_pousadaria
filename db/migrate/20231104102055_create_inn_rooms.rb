class CreateInnRooms < ActiveRecord::Migration[7.1]
  def change
    create_table :inn_rooms do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.integer :dimension, null: false
      t.integer :price, null: false
      t.integer :maximum_number_of_guests, null: false
      t.integer :number_of_bathrooms, null: false
      t.integer :number_of_wardrobes, null: false
      t.boolean :has_balcony, default: false
      t.boolean :has_tv, default: false
      t.boolean :has_air_conditioning, default: false
      t.boolean :has_vault, default: false
      t.boolean :is_accessible_for_people_with_disabilities, default: false
      t.boolean :enabled, default: false
      t.references :inn, null: false, foreign_key: true

      t.timestamps
    end
  end
end
