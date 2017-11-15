desc "This task will mark orders late if it is passed their due date"
task :mark_orders_late => :environment do
  Order.mark_orders_late
end

desc "This task will make sure we have all orders from Shopify from the last 2 weeks"
task :daily_shopify_reconciliation => :environment do
  shopify_key = ENV["SHOPIFY_API_KEY"]
  shopify_password = ENV["SHOPIFY_API_PASSWORD"]
  base_url = "https://#{shopify_key}:#{shopify_password}@skinnyfatties.myshopify.com/admin/orders.json?created_at_min=#{25.hours.ago}"
  response = HTTParty.get(base_url, format: :plain)

  shopify_orders = JSON.parse(response)["orders"]
  db_orders = Order.where(source: "Shopify").where("created_at >= ?", 25.hours.ago)

  needed_orders = shopify_orders.reject do |shopify_order|
    db_orders.where(source_order_id: shopify_order["name"].gsub("#", "")).length > 0
  end

  bad_orders = []
  order_count = Order.count
  minus_dummy_orders_count = needed_orders.count

  if needed_orders.length > 0
    needed_orders.each do |needed_order|
      phone = needed_order["customer"]["default_address"]["phone"]
        .gsub("(", "")
        .gsub(")", "")
        .gsub("-", "")
        .gsub(" ", "")
        .gsub("–", "")
        .gsub("+", "")

      dummy_phones = ["9045668701", "6167804457", "19045668701", "16167804457"]

      if dummy_phones.include? phone
        minus_dummy_orders_count -1
        #return # dont do anything if its an order from jared or brian
      else

        customer = Customer.find_or_create_shopify(needed_order["customer"])

        if !customer.id && phone.length == 11 && phone.split("").first == 1
          needed_order["customer"]["default_address"]["phone"] = phone.slice!(0)
          customer = Customer.find_or_create_shopify(needed_order["customer"])
        elsif  !customer.id && phone.length == 10 && phone.split("").first != 1
          needed_order["customer"]["default_address"]["phone"] = "1#{phone}"
          customer = Customer.find_or_create_shopify(needed_order["customer"])
        end

        if !customer.id
          bad_orders.push(needed_order)
        else
          order_type = needed_order["line_items"]
            .first["title"] == "Air Tailor Welcome Kit" ?
            WelcomeKit : TailorOrder

          order = order_type.find_or_create(needed_order, customer)
          Item.create_items_shopify(order, needed_order["line_items"]) if order_type == TailorOrder
        end
      end
    end
  end

  puts "Order Count: #{order_count}"
  puts "new Order Count: #{Order.count}"
  puts "minus_dummy_orders_count #{minus_dummy_orders_count}"
  puts "bad orders count #{bad_orders.count}"
end
