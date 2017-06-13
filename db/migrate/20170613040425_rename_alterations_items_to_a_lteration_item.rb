class RenameAlterationsItemsToALterationItem < ActiveRecord::Migration[5.0]
  def change
    rename_table :alterations_items, :alteration_items
  end
end
