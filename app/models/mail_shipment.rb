class MailShipment < Shipment

  def deliver_shipment
    :create_shippo_label
  end

  def source_address
    source.for_shippo
  end

  def destination_address
    destination.for_shippo
  end

  def create_shippo_label
    return false unless is_mail_shipment?
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

    # should all of this move to a shippo_worker? yes?
    shippo_shipment = Shippo::Shipment.create(
      object_purpose: "PURCHASE",
      address_from: from,
      address_to: to,
      parcels: parcel,
      async: false
    )

    rate = shippo_shipment.find {|r| r.attributes.include? "BESTVALUE"}

    shippo_transaction = Shippo::Transaction.create(
      rate: rate, label_file_type: "PNG", async: false
    )

    self.shipping_label  = shippo_transaction[:label_url]
    self.tracking_number = shippo_transaction[:tracking_number]
  end

end
