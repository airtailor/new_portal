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

    Item.create_items_for(order, data["line_items"]) if order_type == TailorOrder
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
