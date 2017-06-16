class Api::ShopifyController < ApplicationController
  protect_from_forgery :except => :recieve
  before_action :authenticate_user!, :except => [:receive]
  #before_filter: :welcome_kit_or_tailor_order

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

    customer = Customer.find_or_create(data["customer"])
    order_type = tailor_order_or_welcome_kit(data)
    order = order_type.find_or_create(data, customer)
    #byebug
    Item.create_items_for(order, data["line_items"])
    puts "\n\n\nBLAHHHHHHHHHHhHHHHHHHHHHH\n\n\n"
    {sup: "Hi"}.to_json
  end

  private

  def tailor_order_or_welcome_kit(order_info)
    if order_info["line_items"].first["title"] === "Air Tailor Welcome Kit"
      WelcomeKit
    else
      TailorOrder
    end
  end

  # def find_or_create_customer(customer)
  #   if Customer.find_by(shopify_id: customer["id"])

  #   byebug
  # end

  # def welcome_kit_or_tailor_order
  #   puts "Welcome Kit or Tailor Order"
  # end

  # def create_order(data)
  #   shopify_customer_id: data['customer']['id'],
  #   name: data['customer']['first_name'],
  #   shopify_id: data['name'],
  #   unique_id: data['id'],
  #   total: data['total_price'],
  #   weight: data['total_weight'],
  #   note: data['note'],
  #   alterations: alterations
  # end

  # def find_or_make_customer(shopify_id)
  #   existing_customer = customer.find_by(shopify_id)
  #   if existing_customer
  #     existing_customer
  #   else
  #     # create customer
  #   end
  # end

  # # find a better way to handle tie slimming service
  # if data['line_items'][0]['title'] == "Tie Slimming Service"
  #     order[:tie_amount] = data['line_items'][0]['quantity']
  #   else
  #     order[:tie_amount] = nil
  #   end
  # end
end
