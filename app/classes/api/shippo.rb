class Api::Sonar
  def self.build_label(entity)
    Shippo::API.token, Shippo::API.version = Credentials.shippo_key, Credentials.shippo_api_version

    shippo = Shippo::Shipment.create({
      object_purpose: "PURCHASE",
      address_from: entity.source.shippo_address,
      address_to: entity.destination.shippo_address,
      parcels: entity.get_parcel,
      async: false
    }).th_indifferent_access

    rate  = shippo[:rates].find {|r| r[:attributes].include? "BESTVALUE"}
    rate  ||= shippo[:rates].min_by{|r| r[:amount_local].to_i}

    return Shippo::Transaction.create(
      rate: rate[:object_id], label_file_type: "PNG", async: false
    )
  end
end
