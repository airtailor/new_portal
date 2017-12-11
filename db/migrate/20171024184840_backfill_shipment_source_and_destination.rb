class BackfillShipmentSourceAndDestination < ActiveRecord::Migration[5.0]
  def up
    Shipment.all.each do |shipment|
      # at this point in time, all orders had a single shipment but orders were done
      # via a join.
      order = shipment.orders.first
      source_address, destination_address = nil, nil

      if order
        customer, retailer, tailor = order.customer, order.retailer, order.tailor
        type, order_type = shipment.delivery_type, order.type

        if type == "OutgoingShipment"
          source_address = tailor.address if order_type == "TailorOrder"
          source_address = retailer.address if order_type == "WelcomeKit"

          if order.ship_to_store
            destination_address = retailer.address
          else
            destination_address = customer.addresses.first
          end
        elsif type == "IncomingShipment"
          if retailer.name != "Air Tailor"
            source_address = retailer.address
          else
            source_address = customer.addresses.first
          end

          destination_address = tailor.address
        end
      end

      shipment.source      = source_address
      shipment.destination = destination_address
      shipment.save
    end
  end

  def down
    Shipment.update_all( source: nil, destination: nil)
  end
end
