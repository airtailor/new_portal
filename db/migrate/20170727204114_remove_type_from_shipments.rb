class RemoveTypeFromShipments < ActiveRecord::Migration[5.0]
  def change
    remove_column :shipments, :type
  end
end
