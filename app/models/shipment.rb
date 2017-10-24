class Shipment < ApplicationRecord
  validates :type, :shipping_label, :tracking_number, :weight, presence: true

  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  has_many :shipment_orders
  has_many :orders, through: :shipment_orders

  has_many :addresses, as: :source
  has_many :addresses, as: :destination


  after_initialize :add_order_weight
  after_initialize :configure_shippo
  after_create :text_all_shipment_customers

  private

  def text_all_shipment_customers
    orders.map(&:text_order_customers)
  end

  def add_order_weight
    # NOTE: we need to add weight to items.
    # Weight comes in from Shopify or React, Rails does nothing.
    self.weight = self.orders.sum(:weight)
  end

  def configure_shippo

    Shippo.api_token = ENV["SHIPPO_KEY"]
    # Shippo.api_version = ENV["SHIPPO_API_VERSION"]
    Shippo.api_version = '2017-03-29'

    to_address = source_address
    from_address = destination_address
    parcel = get_parcel

    Rails.logger.info "to_address: #{to_address}"
    Rails.logger.info "from_address: #{from_address}"
    Rails.logger.info "parcel: #{parcel}"

    shippo_shipment = create_shippo_shipment(to_address, from_address, parcel)
    shippo_transaction = create_shippo_transaction(shippo_shipment)
    add_shipping_label(shippo_transaction)
    add_tracking_number(shippo_transaction)
  end

  def source_address(inhabitant)
    source.for_shippo(inhabitant.address)
    #
    # if self.type == "OutgoingShipment"
    #   # outgoing shipments always go to customer! :* )
    #   if self.order.ship_to_store
    #     get_retailer_address
    #   else
    #     get_customer_address
    #   end
    # elsif self.type == "IncomingShipment"
    #   get_tailor_address if self.order.type == "TailorOrder"
    #   get_retailer_address if self.order.type == "WelcomeKit"
    # end
  end

  def destination_address(inhabitant)
    destination.for_shippo(inhabitant.address)

    # if self.type == "OutgoingShipment"
    #   Rails.logger.info "GET SHIP FROM ADDRESS - OUTGOING SHIPMENT order type - #{self.order.type}"
    #   return get_tailor_address if self.order.type == "TailorOrder"
    #   return get_retailer_address if self.order.type == "WelcomeKit"
    # elsif self.type == "IncomingShipment"
    #   return get_customer_address
    # end
  end

  def get_parcel
    if self.order.type == "WelcomeKit"
      {
        length: 6,
        width: 4,
        height: 1,
        distance_unit: :in,
        weight: 28,
        mass_unit: :g
      }
    elsif self.order.type == "TailorOrder"
       {
        length: 7,
        width: 5,
        height: 3,
        distance_unit: :in,
        weight: self.order.weight,
        mass_unit: :g
      }
    end
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
end
