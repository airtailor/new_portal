class Shipment < ApplicationRecord
  include ShipmentConstants

  validates :source, :destination, presence: true
  validates :delivery_type, inclusion: [ MAIL, MESSENGER ], presence: true
  # shipment is created, without shippo stuff
  # deliver method fires to parse + create label on shippo (async)
  # returns to the front-end
  # once it's done, those get saved

  validates :shipping_label, :tracking_number, :weight, presence: true,
    if: :is_mail_shipment?

  belongs_to :source, polymorphic: true
  belongs_to :destination, polymorphic: true

  has_many :shipment_orders
  has_many :orders, through: :shipment_orders

  has_many :addresses, as: :source
  has_many :addresses, as: :destination

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

  # there was an error here for "needs something."
  # i think it was needs_label.
  #  double-check.

  def set_default_fields
    self.weight = order_weight
  end

  def order_weight
    self.orders.sum(:weight)
  end

  def request_messenger
    if is_messenger_shipment?
      PostmatesWorker.perform_async(shipment)
    else
      raise StandardError
    end
  end


  def create_label
    # NOTE: this should work. A single source and single destination.
    # But! it might not later!

    binding.pry

    if is_mail_shipment?
      Shippo.api_token, Shippo.api_version = ENV["SHIPPO_KEY"], ENV["SHIPPO_API_VERSION"]
      #
      shippo = Shippo::Shipment.create(
        object_purpose: "PURCHASE",
        address_from: self.source,
        address_to: self.destination,
        parcels: get_parcel,
        async: false
      )

      rate = shippo.find {|r| r.attributes.include? "BESTVALUE"}
      shippo_txn = Shippo::Transaction.create(
        rate: rate, label_file_type: "PNG", async: false
      )

      self.shipping_label  = shippo_txn[:label_url]
      self.tracking_number = shippo_txn[:tracking_number]
      # ShippoWorker.perform_async(shipment)
    else
      raise StandardError
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
    case self.orders.select(:type).distinct
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
        weight: self.orders.sum(:weight),
        mass_unit: :g
      }
    end
  end


end
