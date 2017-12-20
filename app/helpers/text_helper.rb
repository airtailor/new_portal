module TextHelper
  def alert_for_bad_shopify_order
    error_message =  "Sorry to interupt, but an Order Failed! Shopify id: ##{self.source_order_id}, " +
      "Customer Name: #{self.customer.first_name} #{self.customer.last_name}, " +
      "Order Errors: #{self.errors.full_messages.to_sentence}" +
      "Customer Errors: #{self.customer.errors.full_messages.to_sentence}; #{Time.now}"

    phone_list = ["9045668701", "6167804457"]

    puts "Text: \n#{error_message}"
    puts "Self \n#{self.id} #{self.source_order_id} #{Time.now}"

    phone_list.map do |phone|
      SendSonar.message_customer(text: error_message, to: phone)
    end
  end
end
