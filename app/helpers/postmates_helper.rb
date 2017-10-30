module PostmatesHelper
  # NOTE: This is in-progress and doesn't do anything.
  #
  # def get_delivery_quote
  #   # pings postmates for a quote
  # end
  #
  # def create_delivery(params, parcel)
  #   postmates_id = ENV['POSTMATES_ID']
  #   url = "https:://api.postmates.com/v1/customers/#{postmates_id}/deliveries"
  #   uri = URI.parse(url)
  #
  #   http = Net::HTTP.new(uri.host, uri.port)
  #   request = Net::HTTP::Post.new(uri.request_uri)
  #   request.set_form_data(
  #     # params here
  #   )
  #
  #   response = http.request(request)
  #   # get a delivery
  # end
  #
  # def get_delivery
  #   # given an ID, pings postmates for details
  # end
  #
  # def cancel_delivery
  #   # given an ID, cancels that delivery
  # end
  #
  # def list_deliveries(filter = "all")
  #   # retrieves deliveries
  #   # if filter == "active", only active deliveries
  # end
end
