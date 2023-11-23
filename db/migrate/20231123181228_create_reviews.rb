class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.integer :score, null: false
      t.references :booking, null: false, foreign_key: true
      t.text :guest_commentary
      t.text :innkeeper_reply

      t.timestamps
    end
  end
end
