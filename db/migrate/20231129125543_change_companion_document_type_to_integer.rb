class ChangeCompanionDocumentTypeToInteger < ActiveRecord::Migration[7.1]
  def change
    change_column :companions, :document_type, :integer, null: false
  end
end
