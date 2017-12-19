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
    order = order_type.find_or_create(data, customer)

    if !order.id
      puts "\n\n\nshopify controller order not able to be created"
      puts "\norder: #{order}"
      puts "\ncustomer: #{customer}"
      puts "\n\n\n shopify json #{data}"
    else
      byebug
      order.send_order_confirmation_text
    end

    byebug

    Item.create_items_shopify(order, data["line_items"]) if order_type == TailorOrder
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
end
