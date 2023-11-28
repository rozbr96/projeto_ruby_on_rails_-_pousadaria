class AddFinishedToBilling < ActiveRecord::Migration[7.1]
  def change
    add_column :billings, :finished, :boolean, default: false
  end
end
