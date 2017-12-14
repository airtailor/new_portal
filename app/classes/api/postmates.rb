class Api::Postmates
  def self.build_messenger_delivery(pickup, dropoff)
    @client = Postmates.new
    @client.configure do |config|
      config.api_key = Credentials.postmates_token
      config.customer_id = Credentials.postmates_id
    end

    pickup_address = pickup.postmates_address
    dropoff_address = dropoff.postmates_address
    pickup_contact = pickup.get_contact
    dropoff_contact = dropoff.get_contact

    begin
      quote = @client.quote(
        pickup_address: pickup_address, dropoff_address: dropoff_address
      )
    rescue => e
      raise e
    end

    pickup_notes = pickup.street_two.blank? ? "" : "Unit: #{pickup.street_two}"
    dropoff_notes = dropoff.street_two.blank? ? "" : "Unit: #{dropoff.street_two}"

    params = {
      quote_id: quote.id,
      manifest: postmates_manifest_content,
      manifest_reference: "",
      pickup_name: pickup_contact.name,
      pickup_address: pickup_address,
      pickup_phone_number: pickup_contact.phone,
      pickup_business_name: "",
      pickup_notes: pickup_notes,
      dropoff_name: dropoff_contact.name,
      dropoff_address: dropoff_address,
      dropoff_phone_number: dropoff_contact.phone,
      dropoff_business_name: "",
      dropoff_notes: dropoff_notes
    }

    begin
      return @client.create(params)
    rescue => e
      raise e
    end
  end

  def self.postmates_manifest_content
    "If you have problems with the delivery and cannot reach anyone at the pickup or dropoff phone, please call Brian at (616) 780-4457"
  end
end
