class CreatePaymentMethods < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_methods do |t|
      t.string :name, null: false
      t.boolean :enabled, default: false

      t.timestamps

      t.index :name, unique: true
    end
  end
end
