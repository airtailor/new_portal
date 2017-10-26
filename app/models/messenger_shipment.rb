class MessengerShipment < Shipment
  include PostmatesHelper

  def deliver_shipment

  end

  def configure_shipment_delivery
    :configure_messenger_delivery
  end

  def is_messenger_shipment?
    self.class == MessengerShipment && self.shipment_type === MESSENGER
  end

  def configure_messenger_delivery
    return false unless is_messenger_shipment?
    # NOTE: dummy method for testing.

    # set up params

    # parse source + destination

    # spin up a worker
  end

  def source_address
    source.for_postmates
  end

  def destination_address
    destination.for_postmates
  end

end
