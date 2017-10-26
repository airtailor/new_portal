class MailShipment < Shipment

  def deliver_shipment
    :
  end

  def configure_shipment_delivery
    :configure_shippo_delivery
  end


  def mail_shipment
    self.class == MailShipment && self.shipment_type === MAIL
  end

  def source_address
    source.for_shippo
  end

  def destination_address
    destination.for_shippo
  end

  def configure_shippo_delivery
    return false unless mail_shipment
    # NOTE: this should work. A single source and single destination.
    # But! it might not later!

    Shippo.api_token = ENV["SHIPPO_KEY"]
    # Shippo.api_version = ENV["SHIPPO_API_VERSION"]
    Shippo.api_version = '2017-03-29'

    to, from, parcel = source_address, destination_address, get_parcel

    Rails.logger.info "
      to: #{to}\n\n
      from: #{from}\n\n
      parcel: #{parcel}\n\n
    "

    shippo_shipment = Shippo::Shipment.create(
      object_purpose: "PURCHASE",
      address_from: from,
      address_to: to,
      parcels: parcel,
      async: false
    )

    rate = get_shipping_rate(shippo_shipment)

    shippo_transaction = Shippo::Transaction.create(
      rate: rate, label_file_type: "PNG", async: false
    )

    self.shipping_label  = shippo_transaction[:label_url]
    self.tracking_number = shippo_transaction[:tracking_number]
  end

  def get_shipping_rate(rates)
    rates.find {|r| r.attributes.include? "BESTVALUE"}
  end

end
