class ShippoWorker < ServiceWorker

  def perform(shipment, to, from, parcel)

    Shippo.api_token = ENV["SHIPPO_KEY"]
    Shippo.api_version = ENV["SHIPPO_API_VERSION"]
    # Shippo.api_version = '2017-03-29'

    shippo = Shippo::Shipment.create(
      object_purpose: "PURCHASE",
      address_from: from,
      address_to: to,
      parcels: parcel,
      async: false
    )

    rate = shippo.find {|r| r.attributes.include? "BESTVALUE"}

    # can we make this async?
    shippo_txn = Shippo::Transaction.create(
      rate: rate, label_file_type: "PNG", async: false
    )

    shipment.shipping_label  = shippo_txn[:label_url]
    shipment.tracking_number = shippo_txn[:tracking_number]

    shipment.save
  end
end
