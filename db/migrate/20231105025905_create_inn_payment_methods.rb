class CreateInnPaymentMethods < ActiveRecord::Migration[7.1]
  def change
    create_table :inn_payment_methods do |t|
      t.boolean :enabled, default: false
      t.references :inn, null: false, foreign_key: true
      t.references :payment_method, null: false, foreign_key: true

      t.timestamps

      t.index [:inn_id, :payment_method_id], unique: true
    end
  end
end
