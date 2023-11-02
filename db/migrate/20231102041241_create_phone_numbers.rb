class CreatePhoneNumbers < ActiveRecord::Migration[7.1]
  def change
    create_table :phone_numbers do |t|
      t.string :city_code, null: false
      t.string :number, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :phone_numbers, [:city_code, :number], unique: true
  end
end
