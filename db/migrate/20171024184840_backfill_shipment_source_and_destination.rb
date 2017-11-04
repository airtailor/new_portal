class BackfillShipmentSourceAndDestination < ActiveRecord::Migration[5.0]
  def up
    Shipment.all.each do |shipment|
      # at this point in time, all orders had a single shipment but orders were done
      # via a join.
      order = shipment.orders.first
      source_address, destination_address = nil, nil

      if order
        customer, retailer, tailor = order.customer, order.retailer, order.tailor
        type, order_type = shipment.shipment_type, order.type

        if type == "OutgoingShipment"
          source_address = order.tailor.address if order_type == "TailorOrder"
          source_address = order.retailer.address if order_type == "WelcomeKit"

          if order.ship_to_store
            destination_address = order.retailer.address
          else
            destination_address = order.customer.addresses.first
          end
        elsif type == "IncomingShipment"
          source_address = order.retailer.address if order_type == 'TailorOrder'
          destination_address = order.tailor.addresses.first
        end
      end

      shipment.source      = source_address
      shipment.destination = destination_address
      shipment.save
    end
  end

  def down
    Shipment.update_all(
      source_id: nil, source_type: nil,
      destination_id: nil, destination_type: nil
    )
  end
end
