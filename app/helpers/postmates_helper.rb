module PostmatesHelper
  def create_postmates_delivery
      from = shipment.source.for_postmates
      to   = shipment.destination.for_postmates
      parcel = shipment.get_parcel

      return {
        quote_id: nil
        manifest: # some value here.
        manifest_reference: # probably shipment #?
        pickup_name: from[:full_name]
        pickup_address: from.full_address
        pickup_phone_number: from[:phone_number]
        pickup_business_name: from.business_name || nil
        pickup_notes: # notes?
        dropoff_name: [:full_name]
        dropoff_address: from.full_address
        dropoff_phone_number: from[:phone_number]
        dropoff_business_name: from.business_name || nil
        dropoff_notes: # ??
        requires_id: # ??
      }

    else
      raise StandardError
    end
  end


  # NOTE: This is in-progress and doesn't do anything.
  #
  # def get_delivery_quote
  #   # pings postmates for a quote
  # end
  #
  def create_delivery(params, parcel)
    postmates_token = Credentials.postmates_sandbox_token
    postmates_id = Credentials.postmates_id
    url = "https:://api.postmates.com/v1/customers/#{postmates_id}/deliveries"
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.set_form_data(
      # params here
    )

    response = http.request(request)
    # get a delivery
  end

  def get_delivery
    # given an ID, pings postmates for details
  end

  def cancel_delivery
    # given an ID, cancels that delivery
  end
end
