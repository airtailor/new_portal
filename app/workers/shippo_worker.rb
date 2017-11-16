class ShippoWorker < ServiceWorker

  # NOTE: We need to make ActionCable work to make this work asynchronously.
  # def perform(shipment, to, from, parcel)
  #
  #   Shippo.api_token = ENV["SHIPPO_KEY"]
  #   Shippo.api_version = ENV["SHIPPO_API_VERSION"]
  #   # Shippo.api_version = '2017-03-29'
  #
  #   shippo = Shippo::Shipment.create(
  #     object_purpose: "PURCHASE",
  #     address_from: from,
  #     address_to: to,
  #     parcels: parcel,
  #     async: false
  #   )
  #
  #   if shippo
  #     rate = shippo.find {|r| r.attributes.include? "BESTVALUE"}
  #     shippo_txn = Shippo::Transaction.create(
  #       rate: rate, label_file_type: "PNG", async: false
  #     )
  #
  #     if shippo_txn
  #       shipment.shipping_label  = shippo_txn[:label_url]
  #       shipment.tracking_number = shippo_txn[:tracking_number]
  #     end
  #   end
  #
  #   shipment.save
  # end
end
