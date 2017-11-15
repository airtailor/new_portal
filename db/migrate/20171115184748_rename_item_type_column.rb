class RenameItemTypeColumn < ActiveRecord::Migration[5.0]
  def up
    rename_column :items, :type_id, :item_type_id
  end

  def down
    rename_column :items, :item_type_id, :type_id
  end
end
