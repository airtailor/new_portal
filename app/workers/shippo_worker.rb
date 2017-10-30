class ShippoWorker < ServiceWorker
  # include PostmatesHelper


  def perform(shipment)
    puts "SHIPPO WORKER"
    # Shippo.api_token = ENV["SHIPPO_KEY"]
    # Shippo.api_version = ENV["SHIPPO_API_VERSION"]
    # # Shippo.api_version = '2017-03-29'
    #
    # from = shipment.source.for_shippo
    # to   = shipment.destination.for_shippo
    #
    # parcel = shipment.get_parcel
    #
    # shippo = Shippo::Shipment.create(
    #   object_purpose: "PURCHASE",
    #   address_from: from,
    #   address_to: to,
    #   parcels: parcel,
    #   async: false
    # )
    #
    # rate = shippo.find {|r| r.attributes.include? "BESTVALUE"}
    #
    # shippo_txn = Shippo::Transaction.create(
    #   rate: rate, label_file_type: "PNG", async: false
    # )
    #
    # shipment.shipping_label  = shippo_txn[:label_url]
    # shipment.tracking_number = shippo_txn[:tracking_number]
    #
    # shipment.save
  end
end
