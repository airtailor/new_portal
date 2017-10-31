class RemoveShipmentFromShipments < ActiveRecord::Migration[5.0]
  def change
    remove_column :shipments, :shipment, :string
  end
end
