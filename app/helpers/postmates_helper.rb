module PostmatesHelper

  def get_delivery_quote
    # pings postmates for a quote
  end

  def create_delivery
    # get a delivery
  end

  def get_delivery
    # given an ID, pings postmates for details
  end

  def cancel_delivery
    # given an ID, cancels that delivery
  end

  def list_deliveries(filter = "all")
    # retrieves deliveries
    # if filter == "active", only active deliveries
  end
end
