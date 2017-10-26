class MessengerShipment < Shipment

  def request_messenger(quote_id)
    return false unless is_messenger_shipment?
    params = self.as_postmates_object.merge({quote_id: quote_id})

    PostmatesWorker.create_messenger_delivery(params)
  end

  def source_address
    source.for_postmates
  end

  def destination_address
    destination.for_postmates
  end

end
