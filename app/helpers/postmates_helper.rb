module PostmatesHelper
  def create_postmates_delivery
    @client = Postmates.new
    @client.configure do |config|
      config.api_key = Credentials.postmates_sandbox_token
      config.customer_id = Credentials.postmates_id
    end


    pickup, dropoff = self.source, self.destination
    pickup_address = pickup.postmates_address
    dropoff_address = dropoff.postmates_address
    pickup_contact = source.get_contact
    dropoff_contact = destination.get_contact

    quote = @client.quote(
      pickup_address: pickup_address, dropoff_address: dropoff_address
    )
    # if this 400s, we're boned.
    # not a big deal rn, but later it will be.

    params = {
      quote_id: quote.id,
      manifest: postmates_manifest_content,
      manifest_reference: "",
      pickup_name: pickup_contact.name,
      pickup_address: pickup_address,
      pickup_phone_number: pickup_contact.phone,
      pickup_business_name: "",
      pickup_notes: "",
      dropoff_name: dropoff_contact.name,
      dropoff_address: dropoff_address,
      dropoff_phone_number: dropoff_contact.phone,
      dropoff_business_name: "",
      dropoff_notes: ""
    }

    return @client.create(params)
  end

  def postmates_manifest_content
    "Some stuff to send to postmates about a delivery."
  end

end
