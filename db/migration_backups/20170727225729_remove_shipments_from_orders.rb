class RemoveShipmentsFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :incoming_shipment_id
    remove_column :orders, :outgoing_shipment_id
  end
end
