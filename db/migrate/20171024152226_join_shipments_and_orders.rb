class JoinShipmentsAndOrders < ActiveRecord::Migration[5.0]
  def up
    create_table :shipment_orders do |t|
      t.references :shipment, index: true
      t.references :order, index: true
    end
  end

  def down
    drop_table :shipment_orders
  end
end
