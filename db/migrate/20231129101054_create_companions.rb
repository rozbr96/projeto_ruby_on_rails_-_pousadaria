class CreateCompanions < ActiveRecord::Migration[7.1]
  def change
    create_table :companions do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :document_number, null: false
      t.string :document_type, null: false
      t.string :name, null: false

      t.timestamps
    end

    add_index :companions, [:booking_id, :document_number], unique: true
  end
end
