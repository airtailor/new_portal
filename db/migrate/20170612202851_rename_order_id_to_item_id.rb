class RenameOrderIdToItemId < ActiveRecord::Migration[5.0]
  def change
    rename_column :items, :order_id_type, :type_id
  end
end
