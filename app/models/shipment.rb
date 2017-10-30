class Shipment < ApplicationRecord
  include ShipmentConstants

  validates :type, :shipping_label, :tracking_number, :weight, presence: true
  belongs_to :order

  after_initialize :add_order_weight
  after_initialize :configure_shippo
  after_create :send_text_to_customer

  # NOTE: Commented fields are in-flight. Below is the complete model.

  # validates :shipment_type, inclusion: [ MAIL, MESSENGER ], presence: true
  # validates :shipping_label, :tracking_number, :weight, presence: true,
  #   if: :mail_shipment

  # belongs_to :source, polymorphic: true
  # belongs_to :destination, polymorphic: true
  # has_many :shipment_orders
  # has_many :orders, through: :shipment_orders

  # has_many :addresses, as: :source
  # has_many :addresses, as: :destination


  # after_create :text_all_shipment_customers

  # def request_messenger
  #   if is_messenger_shipment?
  #     PostmatesWorker.perform_async(shipment)
  #   else
  #     raise StandardError
  #   end
  # end
  #
  # def create_label
  #   # NOTE: this should work. A single source and single destination.
  #   # But! it might not later!
  #   if is_mail_shipment?
  #     ShippoWorker.perform_async(shipment)
  #   else
  #     raise StandardError
  #   end
  # end
  #
  # def is_messenger_shipment?
  #   self.shipment_type === MESSENGER
  # end
  #
  # def is_mail_shipment?
  #   self.shipment_type === MAIL
  # end
  #
  # def add_order_weight
  #   # NOTE: we need to add weight to items.
  #   # Weight comes in from Shopify or React, Rails does nothing.
  #   self.weight = self.orders.sum(:weight)
  # end
  #
  # def text_all_shipment_customers
  #   # this shouldn't be generic
  #   orders.map(&:text_order_customers)
  # end
  #
  # def get_parcel
  #   # NOTE: This will break rapidly! We're defaulting to the first one because we don't
  #   # bundle them yet.
  #
  #   case orders.first.type
  #   when "WelcomeKit"
  #     return {
  #       length: 6,
  #       width: 4,
  #       height: 1,
  #       distance_unit: :in,
  #       weight: 28,
  #       mass_unit: :g
  #     }
  #   when "TailorOrder"
  #      return {
  #       length: 7,
  #       width: 5,
  #       height: 3,
  #       distance_unit: :in,
  #       weight: self.order.weight,
  #       mass_unit: :g
  #     }
  #   end
  # end

private

  def get_customer_address
    self.order.customer.shippo_address
  end

  def get_tailor_address
    self.order.tailor.shippo_address
  end

  def get_retailer_address
    self.order.retailer.shippo_address
  end


  def send_text_to_customer
    if ((self.order.retailer.name != "Air Tailor") && (self.type == "OutgoingShipment"))
      customer = self.order.customer
      customer_message = "Good news, #{customer.first_name.capitalize} -- your " +
        "Airtailor Order (id: #{self.order.id}) is finished and is on its way to you! " +
        "Here's your USPS tracking number: #{self.tracking_number}"
      SendSonar.message_customer(text: customer_message, to: customer.phone)
    end
  end

  def configure_shippo
    Shippo.api_token = ENV["SHIPPO_KEY"]
    Shippo.api_version = '2017-03-29'
    to_address = get_ship_to_address
    from_address = get_ship_from_address
    parcel = get_parcel
    puts "\n\n\n to_address #{to_address}"
    puts "\n\n\n from_address #{from_address}"
    puts "\n\n\n parcel #{parcel}"
    shippo_shipment = create_shippo_shipment(to_address, from_address, parcel)
    shippo_transaction = create_shippo_transaction(shippo_shipment)
    add_shipping_label(shippo_transaction)
    add_tracking_number(shippo_transaction)
  end


  def add_order_weight
    self.weight = self.order.weight
  end


  def create_shippo_shipment(to_address, from_address, parcel)
    shipment = Shippo::Shipment.create(
      object_purpose: "PURCHASE",
      address_from: from_address,
      address_to: to_address,
      parcels: parcel,
      async: false
    )
  end

  def get_shipping_rate(rates)
    rates.find {|r| r.attributes.include? "BESTVALUE"}
  end

  def create_shippo_transaction(shippo_shipment)
    transaction = Shippo::Transaction.create(
      #rate: shippo_shipment[:rates].first[:object_id],
      #rate: shippo_shipment[:rates].find {|r| r.attributes.include? "BESTVALUE"},
      rate: get_shipping_rate(shippo_shipment[:rates]),
      label_file_type: "PNG",
      async: false
    )
  end

  def add_shipping_label(shippo_transaction)
    self.shipping_label = shippo_transaction[:label_url]
  end

  def add_tracking_number(shippo_transaction)
    self.tracking_number = shippo_transaction[:tracking_number]
  end

  def get_parcel
    # NOTE: This will break rapidly! We're defaulting to the first one because we don't
    # bundle them yet.

    case self.order.type
    when "WelcomeKit"
      return {
        length: 6,
        width: 4,
        height: 1,
        distance_unit: :in,
        weight: 28,
        mass_unit: :g
      }
    when "TailorOrder"
       return {
        length: 7,
        width: 5,
        height: 3,
        distance_unit: :in,
        weight: self.order.weight,
        mass_unit: :g
      }
    end
  end

end
