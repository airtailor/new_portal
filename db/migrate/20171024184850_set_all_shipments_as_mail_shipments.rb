class SetAllShipmentsAsMailShipments < ActiveRecord::Migration[5.0]

  def up
    Shipment.update_all(delivery_type: 'mail_shipment')
  end

  def down
    # NOTE: These two classes were subclassed from Shipment.

    # This validation was on Shipment
    # validates :delivery_type, inclusion: { in:
    #   [ MAIL, MESSENGER, "OutgoingShipment", "IncomingShipment" ]
    # }, presence: true

    # Full classes:
    # class OutgoingShipment < Shipment
    # end

    # class IncomingShipment < Shipment
    # end

    # - 11/4/17 NABM

    raise IrreversibleMigration unless OutgoingShipment && IncomingShipment

    Shipment.all.each do |shipment|
      orders = shipment.orders

      order_type = orders.select(:type).distinct
      source_type = shipment.source.address_type
      destination_type = shipment.destination.address_type

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
