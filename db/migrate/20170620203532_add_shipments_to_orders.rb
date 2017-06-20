class AddShipmentsToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :incoming_shipment_id, :integer
    add_column :orders, :outgoing_shipment_id, :integer
  end
end
