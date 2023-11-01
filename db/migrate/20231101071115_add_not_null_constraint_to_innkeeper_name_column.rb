class AddNotNullConstraintToInnkeeperNameColumn < ActiveRecord::Migration[7.1]
  def change
    change_column_null :innkeepers, :name, false
  end
end
