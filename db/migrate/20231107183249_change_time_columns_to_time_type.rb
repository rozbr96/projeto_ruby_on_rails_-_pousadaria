class ChangeTimeColumnsToTimeType < ActiveRecord::Migration[7.1]
  def change
    change_column :inns, :check_in, :time, null: false
    change_column :inns, :check_out, :time, null: false
  end
end
