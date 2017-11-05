class Shipment < ApplicationRecord
  include ShipmentConstants
  include PostmatesHelper
  include ShippoHelper

  validates :source, :destination, presence: true
  validates :delivery_type, inclusion: { in:
    [ MAIL, MESSENGER, "OutgoingShipment", "IncomingShipment" ]
  }, presence: true

  validates :source_type, inclusion: { in: [ 'Address' ] }, presence: true
  validates :destination_type, inclusion: { in: [ 'Address' ] }, presence: true
  # shipment is created, without shippo stuff
  # deliver method fires to parse + create label on shippo (async)
  # returns to the front-end
  # once it's done, those get saved

  validates :shipping_label, :tracking_number, :weight, presence: true,
    if: :is_mail_shipment?

  # validates :postmates_delivery_id, presence: true,
  #   if: :is_messenger_shipment?

  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  has_many :shipment_orders
  has_many :orders, through: :shipment_orders

  def deliver
    case self.delivery_type
    when MAIL
      create_label
    when MESSENGER
      request_messenger
    else
      raise StandardError
    end
  end

  def needs_messenger
    # just returns true for now
    !postmates_delivery_id
  end

  def request_messenger
    if is_messenger_shipment? && needs_messenger
      delivery = self.create_postmates_delivery
      # self.postmates_delivery_id = delivery.id
    end
  end

  def set_default_fields
    self.weight = order_weight
  end

  def order_weight
    self.orders.sum(:weight)
  end

  def needs_label
    !shipping_label || !tracking_number
  end

  def create_label
    # check for needing a label here
    if is_mail_shipment? && needs_label
      shippo_txn = build_shippo_label
      self.shipping_label  = shippo_txn[:label_url]
      self.tracking_number = shippo_txn[:tracking_number]
    end
  end
  #
  def is_messenger_shipment?
    self.delivery_type === MESSENGER
  end

  def is_mail_shipment?
    self.delivery_type === MAIL
  end
  #
  def text_all_shipment_customers
    # this shouldn't be generic
    orders.map(&:text_order_customers)
  end

  def get_parcel
    all_order_types = self.orders.map(&:type).uniq
    return nil if all_order_types.length > 1

    case all_order_types.first
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
        weight: self.orders.sum(&:weight),
        mass_unit: :g
      }
    end
  end

  def parse_src_dest(action)
    type = self.delivery_type

    case action
    when SHIP_RETAILER_TO_TAILOR
      [:retailer, :tailor]
    when SHIP_TAILOR_TO_RETAILER
      type == MAIL ? [:tailor, :retailer] : nil
    when SHIP_CUSTOMER_TO_TAILOR
      type == MAIL ? [:customer, :tailor] : nil
    when SHIP_TAILOR_TO_CUSTOMER
      type == MAIL ? [:tailor, :customer] : nil
    when SHIP_RETAILER_TO_CUSTOMER
      type == MAIL ? [:retailer, :customer] : nil
    else
      nil
    end
  end

  def can_be_executed?(action)
    source, dest = parse_src_dest(action)
    return true if self.orders.length == 1

    counts = {
      retailer: orders.map(&:requester_id).uniq,
      tailor: orders.map(&:provider_id).uniq,
      customer: orders.map(&:customer_id).uniq
    }

    return [source, dest].all?{ |klass|
      counts[klass] == 1
    }
  end

  def set_source(source_model)
    self.source = get_address(source_model)
  end

  def set_destination(destination_model)
    self.destination = get_address(destination_model)
  end

  def get_address(klass)
    record = self.orders.first.send(klass)
    if klass == :customer
      return record.addresses.first
    else
      return record.address
    end
  end



end
