class RenameOrderIdToItemId < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :type_id, :integer
  end
end
