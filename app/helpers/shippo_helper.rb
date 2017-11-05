module ShippoHelper
  def build_shippo_label
    Shippo::API.token, Shippo::API.version = Credentials.shippo_key, Credentials.shippo_api_version

    shippo = Shippo::Shipment.create({
      object_purpose: "PURCHASE",
      address_from: shippo_address(self.source),
      address_to: shippo_address(self.destination),
      parcels: get_parcel,
      async: false
    }).with_indifferent_access

    rate  = shippo[:rates].find {|r| r[:attributes].include? "BESTVALUE"}
    rate  ||= shippo[:rates].min_by{|r| r[:amount_local].to_i}

    return Shippo::Transaction.create(
      rate: rate[:object_id], label_file_type: "PNG", async: false
    )
  end

  def shippo_address(address)
    contact = address.get_contact
    return {
      :name => contact.name,
      :street1 => "#{number} #{street}",
      :street2 => "#{unit} #{floor}",
      :city => self.city,
      :country => self.country,
      :state => self.state_province,
      :zip => self.zip_code,
      :phone => contact.try(:phone),
      :email => contact.try(:email)
    }
  end

end
