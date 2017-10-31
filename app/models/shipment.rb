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

  def deliver
    case self.shipment_type
    when MAIL
      create_label
    when MESSENGER
      request_messenger
    else
      raise StandardError
    end
  end

  def set_source_and_destination(params)
    src, dest = params[:shipment_path]

    src_model = case src
                when 'retailer'
                  Retailer
                when 'tailor'
                  Tailor
                when 'customer'
                  if params[:dest_type] != 'retailer'
                    Customer
                  end
                else
                  nil
                end

    dest_model =  case dest
                  when 'retailer'
                    Retailer
                  when 'tailor'
                    Tailor
                  when 'customer'
                    if params[:source_type] != 'retailer'
                      Customer
                    end
                  else
                    nil
                  end

    return nil unless src_model && dest_model

    self.source      = src_model.where(id: params[:source_id]).first
    self.destination = dest_model.where(id: params[:dest_id]).first
  end

  def set_default_fields
    self.weight = order_weight
  end

  def order_weight
    self.orders.sum(:weight)
  end

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
