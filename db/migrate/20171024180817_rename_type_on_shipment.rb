class RenameTypeOnShipment < ActiveRecord::Migration[5.0]
  def up
    rename_column :shipments, :type, :delivery_type
  end

  def down
    rename_column :shipments, :delivery_type, :type
  end

end
