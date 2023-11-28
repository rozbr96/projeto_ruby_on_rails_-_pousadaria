class CreateBillingItems < ActiveRecord::Migration[7.1]
  def change
    create_table :billing_items do |t|
      t.references :billing, null: false, foreign_key: true
      t.string :description, null: false
      t.integer :unit_price, null: false
      t.integer :amount, null: false

      t.timestamps
    end
  end
end
