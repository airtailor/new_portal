module TextHelper
  def self.alert_for_bad_shopify_order
    error_message =  "An Order Failed: Shopify id: ##{self.source_order_id}, " +
      "Customer Name: #{self.customer.first_name} #{self.customer.last_name}, " +
      "Order Errors: #{self.errors.full_messages}" +
      "Customer Errors: #{self.customer.errors.full_messages}"

    phone_list = ["9045668701", "6167804457"]

    phone_list.map do |phone|
      SendSonar.message_customer(text: error_message, to: phone)
    end
  end
end
