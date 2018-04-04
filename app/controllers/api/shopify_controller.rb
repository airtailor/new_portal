class Api::ShopifyController < ApplicationController
  #protect_from_forgery :except => :recieve
  protect_from_forgery with: :null_session
  before_action :authenticate_user!, :except => [:receive]

  # receive request yes
  # create or find customer yes
  # determine if tailor order or welcomekit ?

  # create order yes
  # create items yes
  # for each item, add alteration yes
  # may need to check if order already exists (multiple requests for same orer) ?
  # make shipping thing

  def receive
    data = JSON.parse(request.body.read)

    phone = data["customer"]["default_address"]["phone"]
      .gsub("(", "")
      .gsub(")", "")
      .gsub("-", "")
      .gsub(" ", "")
      .gsub("–", "")
      .gsub("+", "")

    customer = Customer.find_or_create_shopify(data["customer"])

    if !customer.id && phone.length == 11 && phone.split("").first == 1
      data["customer"]["default_address"]["phone"] = phone.slice!(0)
      customer = Customer.find_or_create_shopify(data["customer"])
    elsif !customer.id && phone.length == 10 && phone.split("").first != 1
      data["customer"]["default_address"]["phone"] = "1#{phone}"
      customer = Customer.find_or_create_shopify(data["customer"])
    end

    order_type = tailor_order_or_welcome_kit(data)
    begin
      order = order_type.find_or_create(data, customer)
    rescue => e
      if !order
        order = Order.new({source_order_id: data["name"], source: "Shopify", retailer: Retailer.first})
        customer = Customer.find_or_create_shopify(data["customer"])
        order.customer = customer
        puts "\n\n\nshopify controller order not able to be created"
        puts "\norder: #{order} #{order.source_order_id} #{data["name"]}"
        puts "\ncustomer: #{customer}"
        puts "\n\n\n shopify json #{data}"
        order.alert_for_bad_shopify_order
      end
    end

    if order.id
      order.send_order_confirmation_text
      items = update_line_items_with_quantity(data["line_items"]) || data["line_items"]
      Item.create_items_shopify(order, items) if order_type == TailorOrder
    end

    render json: {}, status: 200
  end

  private

  def tailor_order_or_welcome_kit(order_info)
    if order_info["line_items"].first["title"] == "Air Tailor Welcome Kit"
      WelcomeKit
    else
      TailorOrder
    end
  end

  def update_line_items_with_quantity(line_items)
    total_quantity = line_items.inject(0) { |prev, curr| prev + curr["quantity"].to_i }

    items = []
    line_items.each do |x|
      x["quantity"].to_i.times { items.push(x) }
    end

    numberless_items = items.map do |item|
      if item["title"].count("0-9") > 0
        item["title"] = item["title"].split(" ")[0..-2].join(" ")
      end
      item
    end

    filtered_items = numberless_items.reject do |item|
      item["title"] == item["variant_title"]
    end

    item_tracker = {}
    numbered_items = filtered_items.map do |item|

      if !item_tracker[item["title"]]
        item_tracker[item["title"]] = 1
      else
        item_tracker[item["title"]] = item_tracker[item["title"]] + 1
      end

      new_title = "#{item["title"]} ##{item_tracker[item["title"]]}"

      # need to make sure we dont modify the original object in memeory
      new_item = item.dup

      new_item["title"] = new_title
      new_item
    end
    return numbered_items
  end
end
