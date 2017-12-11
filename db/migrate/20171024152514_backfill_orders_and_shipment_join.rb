class BackfillOrdersAndShipmentJoin < ActiveRecord::Migration[5.0]
  def up
    Shipment.all.each do |shipment|
      order = Order.where(id: shipment.order_id).first
      if order
        shipment.shipment_orders.create(order: order)
      end
    end

    remove_reference :shipments, :order
  end

  def down
    add_reference :shipments, :order

    ShipmentOrder.all.each do |shipment_order|
      order = Order.where(id: shipment_order.order_id).first
      shipment_order.shipment.update(order: order)
    end
  end
end
