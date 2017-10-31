class Shipment < ApplicationRecord
  include ShipmentConstants

  after_initialize :configure_shippo
  after_create :send_text_to_customer

  # NOTE: Commented fields are in-flight. Below is the complete model.

  validates :shipment_type, inclusion: [ MAIL, MESSENGER ], presence: true
  validates :shipping_label, :tracking_number, :weight, presence: true,
    if: :is_mail_shipment?

  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  has_many :shipment_orders
  has_many :orders, through: :shipment_orders

  has_many :addresses, as: :source
  has_many :addresses, as: :destination


  after_create :text_all_shipment_customers

  def request_messenger
    if is_messenger_shipment?
      PostmatesWorker.perform_async(shipment)
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


end
