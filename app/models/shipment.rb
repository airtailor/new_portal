class Shipment < ApplicationRecord
  include ShipmentConstants

  after_initialize :add_order_weight
  after_initialize :configure_shippo
  after_create :send_text_to_customer

  # NOTE: Commented fields are in-flight. Below is the complete model.

  validates :shipment_type, inclusion: [ MAIL, MESSENGER ], presence: true
  validates :shipping_label, :tracking_number, :weight, presence: true,
    if: :mail_shipment

  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  has_many :shipment_orders
  has_many :orders, through: :shipment_orders

  has_many :addresses, as: :source
  has_many :addresses, as: :destination


  after_create :text_all_shipment_customers

  # def request_messenger
  #   if is_messenger_shipment?
  #     PostmatesWorker.perform_async(shipment)
  #   else
  #     raise StandardError
  #   end
  # end
  #
  def create_label
    # NOTE: this should work. A single source and single destination.
    # But! it might not later!
    if is_mail_shipment?
      ShippoWorker.perform_async(shipment)
    else
      raise StandardError
    end
  end
  #
  def is_messenger_shipment?
    self.shipment_type === MESSENGER
  end

  def is_mail_shipment?
    self.shipment_type === MAIL
  end
  #
  def add_order_weight
    # NOTE: we need to add weight to items.
    # Weight comes in from Shopify or React, Rails does nothing.
    self.weight = self.orders.sum(:weight)
  end
  #
  def text_all_shipment_customers
    # this shouldn't be generic
    orders.map(&:text_order_customers)
  end
  #
  def get_parcel
    # NOTE: This will break rapidly! We're defaulting to the first one because we don't
    # bundle them yet.

    case orders.first.type
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

private
  def get_ship_to_address
    if self.type == "OutgoingShipment"
      # outgoing shipments always go to customer! :* )
      if self.order.ship_to_store
        get_retailer_address
      else
        get_customer_address
      end
    elsif self.type == "IncomingShipment"
      if self.order.type == "TailorOrder"
        get_tailor_address
      end
      # Incoming Shipments should only be going to Tailor
      #get_retailer_address if self.order.type == "WelcomeKit"
    end
  end

  def get_ship_from_address
    if self.type == "OutgoingShipment"
      puts "GET SHIP FROM ADDRESS - OUTGOING SHIPMENT order type - #{self.order.type}"
      return get_tailor_address if self.order.type == "TailorOrder"
      return get_retailer_address if self.order.type == "WelcomeKit"
    elsif self.type == "IncomingShipment"
      return get_customer_address
    end
  end

  def get_customer_address
    address = self.order.customer.try(:shippo_address)
    return self.order.retailer.shippo_address if !address
    address
  end

  def get_tailor_address
    self.order.tailor.shippo_address
  end

  def get_retailer_address
    self.order.retailer.shippo_address
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

    self.shipping_label = shippo_transaction[:label_url]
    self.tracking_number = shippo_transaction[:tracking_number]
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

end
