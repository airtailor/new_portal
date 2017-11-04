class RenameTypeOnShipment < ActiveRecord::Migration[5.0]
  def up
    rename_column :shipments, :type, :shipment_type
  end

  def down
    rename_column :shipments, :shipment_type, :type
  end

end
