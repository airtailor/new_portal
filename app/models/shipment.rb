class Shipment < ApplicationRecord
  include ShipmentConstants

  validates :shipment_type, inclusion: [ MAIL, MESSENGER ], presence: true
  validates :shipping_label, :tracking_number, :weight, presence: true,
    if: :is_mail_shipment?

  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  has_many :shipment_orders
  has_many :orders, through: :shipment_orders

  has_many :addresses, as: :source
  has_many :addresses, as: :destination

  def request_messenger
    if is_messenger_shipment?
      PostmatesWorker.perform_async(shipment)
      text_all_shipment_customers
    else
      raise StandardError
    end
  end
  #
  def create_label
    # NOTE: this should work. A single source and single destination.
    # But! it might not later!
    if is_mail_shipment?
      ShippoWorker.perform_async(shipment)
      text_all_shipment_customers
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
  def text_all_shipment_customers
    # this shouldn't be generic
    orders.map(&:text_order_customers)
  end

  def set_default_fields
    self.source ||= "Shopify"
    self.retailer ||= Retailer.where(company: Company.where(name: "Air Tailor").select(:id)).first
    self.fulfilled ||= false
    self.weight = self.orders.sum(:weight)

    stores_with_tailors = [
      "Steven Alan - Tribeca",
      "Frame Denim - SoHo",
      "Rag & Bone - SoHo"
    ]

    if self.retailer.name.in? stores_with_tailors
      self.tailor = Tailor.where(name: "Tailoring NYC").first
    end
  end

  def get_parcel
    # NOTE: This will break rapidly! We're defaulting to the first one because we don't
    # bundle them yet.
    case order.first.type
    when Order::WELCOME_KIT
      return {
        length: 6,
        width: 4,
        height: 1,
        distance_unit: :in,
        weight: 28,
        mass_unit: :g
      }
    when Order::TAILOR_ORDER
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
