class Shipment < ApplicationRecord
  include ShipmentConstants

  validates :shipment_type, inclusion: [ MAIL, MESSENGER ], presence: true

  validates :shipping_label, :tracking_number, :weight, presence: true,
    if: :mail_shipment

  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  has_many :shipment_orders
  has_many :orders, through: :shipment_orders

  has_many :addresses, as: :source
  has_many :addresses, as: :destination

  after_initialize :add_order_weight
  after_initialize :configure_shippo
  # after_create :text_all_shipment_customers

  def send_shipment
    send(configure_shipment_delivery)
    send(deliver_shipment)
  end

  def configure_shipment_delivery
    raise StandardError
  end

  def deliver_shipment
    raise StandardError
  end

  private

  def text_all_shipment_customers
    # this shouldn't be generic
    orders.map(&:text_order_customers)
  end

  def add_order_weight
    # NOTE: we need to add weight to items.
    # Weight comes in from Shopify or React, Rails does nothing.
    self.weight = self.orders.sum(:weight)
  end

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

end
