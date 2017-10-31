class AddShipToStoreToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :ship_to_store, :boolean
  end
end
