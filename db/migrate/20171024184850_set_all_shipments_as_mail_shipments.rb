class SetAllShipmentsAsMailShipments < ActiveRecord::Migration[5.0]

  def up
    Shipment.update_all(delivery_type: 'mail_shipment')
  end

  def down
    # These two classes were subclassed from Shipment.

    # class OutgoingShipment < Shipment
    # end

    # class IncomingShipment < Shipment
    # end

    raise IrreversibleMigration unless OutgoingShipment && IncomingShipment

    Shipment.all.each do |shipment|
      orders = shipment.orders

      order_type = orders.select(:order_type).distinct
      source_type = shipment.source.address.address_type
      destination_type = shipment.destination.address.address_type

      is_incoming_shipment   = order_type == "TailorOrder" && source_type == 'tailor'
      is_incoming_shipment ||= order_type == "WelcomeKit" && source_type == 'retailer'
      is_incoming_shipment   =  is_incoming_shipment && destination_type

      is_outgoing_shipment = order_type == "TailorOrder"
      is_outgoing_shipment ||=  order_type == "tailor_order"

      if is_incoming_shipment
        shipment.delivery_type = 'IncomingShipment'
      elsif is_outgoing_shipment
        shipment.delivery_type = 'OutgoingShipment'
      end

      shipment.save
    end

  end
end
