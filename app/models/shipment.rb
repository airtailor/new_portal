class Shipment < ApplicationRecord
  include ShipmentConstants

  validates :type, :shipping_label, :tracking_number, :weight, presence: true

  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  has_many :shipment_orders
  has_many :orders, through: :shipment_orders

  has_many :addresses, as: :source
  has_many :addresses, as: :destination


  after_initialize :add_order_weight
  after_initialize :configure_shippo
  # after_create :text_all_shipment_customers

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

    # These should be autoloaded!
    Shippo.api_token = ENV["SHIPPO_KEY"]
    # Shippo.api_version = ENV["SHIPPO_API_VERSION"]
    Shippo.api_version = '2017-03-29'

    to, from, parcel = source_address, destination_address, get_parcel

    Rails.logger.info "to: #{to}"
    Rails.logger.info "from: #{from}"
    Rails.logger.info "parcel: #{parcel}"

    shippo_shipment = Shippo::Shipment.create(
      object_purpose: "PURCHASE",
      address_from: from,
      address_to: to,
      parcels: parcel,
      async: false
    )

    rate = get_shipping_rate(shippo_shipment)

    shippo_transaction = Shippo::Transaction.create(
      rate: rate, label_file_type: "PNG", async: false
    )

    self.shipping_label  = shippo_transaction[:label_url]
    self.tracking_number = shippo_transaction[:tracking_number]
  end

  def source_address
    source.for_shippo
  end

  def destination_address
    destination.for_shippo
  end

  def get_parcel
    case order.type
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

  def get_shipping_rate(rates)
    rates.find {|r| r.attributes.include? "BESTVALUE"}
  end

end
