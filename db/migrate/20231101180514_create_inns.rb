class CreateInns < ActiveRecord::Migration[7.1]
  def change
    create_table :inns do |t|
      t.string :name, null: false
      t.string :corporate_name, null: false
      t.string :registration_number, null: false
      t.string :description, null: false
      t.boolean :pets_are_allowed, null: false
      t.string :usage_policies, null: false
      t.string :email, null: false
      t.boolean :enabled, null: false
      t.references :innkeeper, null: false, foreign_key: true
      t.string :check_in, null: false
      t.string :check_out, null: false

      t.timestamps
    end
    add_index :inns, :registration_number, unique: true
    add_index :inns, :email, unique: true
  end
end
