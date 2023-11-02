class CreateInnPhoneNumbers < ActiveRecord::Migration[7.1]
  def change
    create_table :inn_phone_numbers do |t|
      t.references :inn, null: false, foreign_key: true
      t.references :phone_number, null: false, foreign_key: true

      t.timestamps

      t.index [:inn_id, :phone_number_id], unique: true
    end
  end
end
