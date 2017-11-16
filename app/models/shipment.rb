class Shipment < ApplicationRecord
  include ShipmentConstants
  include DeliveryHelper

  belongs_to :source, inverse_of: :shipments, polymorphic: true
  belongs_to :destination, inverse_of: :shipments, polymorphic: true

  has_many :shipment_orders
  has_many :orders, through: :shipment_orders

  validates :source, :destination, presence: true
  validates :delivery_type,
    inclusion: { in: [ MAIL, MESSENGER, OUTGOING, INCOMING ] }, presence: true

  validates :shipping_label, :tracking_number, :weight, presence: true,
    if: :is_mail_shipment?

  validates :postmates_delivery_id, presence: true, if: :is_messenger_shipment?

  def shipment_action=(action)
    @shipment_action = action if action.in?(legal_shipment_actions)
  end

  def shipment_action
    @shipment_action
  end

  def deliver
    case self.delivery_type
    when MAIL
      if is_mail_shipment? && needs_label
        delivery = create_label(self)
      end
    when MESSENGER
      if is_messenger_shipment? && needs_messenger
        delivery = request_messenger
      end
    end
    self.shipping_label  = delivery.try(:label_url)
    self.tracking_number = delivery.try(:tracking_number)
    self.postmates_delivery_id = delivery.try(:id)
    self.status = delivery.try(:status)
  end

  def needs_messenger
    !self.postmates_delivery_id || !self.status
  end

  def set_default_fields
    self.weight = self.orders.sum(:weight)
  end

  def needs_label
    !shipping_label || !tracking_number
  end

  def is_messenger_shipment?
    self.delivery_type == MESSENGER
  end

  def is_mail_shipment?
    self.delivery_type == MAIL
  end
  #
  def text_all_shipment_customers
    orders.map(&:text_order_customers)
  end

  def set_delivery_method(action)
    orders = self.orders
    source_model, dest_model = self.parse_src_dest(action)
    if delivery_can_be_executed?(source_model, dest_model, orders)
      self.source = get_address(source_model)
      if orders.any?{|o| o.ship_to_store} && dest_model == :customer
        self.destination = get_address(:retailer)
      else
        self.destination = get_address(dest_model)
      end
    end
  end

  def parse_src_dest(action)
    type = self.delivery_type
    case action
    when SHIP_RETAILER_TO_TAILOR
      return [:retailer, :tailor]
    when SHIP_TAILOR_TO_RETAILER
      return type == MAIL ? [:tailor, :retailer] : nil
    when SHIP_CUSTOMER_TO_TAILOR
      return type == MAIL ? [:customer, :tailor] : nil
    when SHIP_TAILOR_TO_CUSTOMER
      return type == MAIL ? [:tailor, :customer] : nil
    when SHIP_RETAILER_TO_CUSTOMER
      return type == MAIL ? [:retailer, :customer] : nil
    else
      return nil
    end
  end

  def delivery_can_be_executed?(source, dest, orders)
    return true if orders.length == 1
    counts = {
      retailer: orders.map(&:requester_id).uniq.count,
      tailor: orders.map(&:provider_id).uniq.count,
      customer: orders.map(&:customer_id).uniq.count
    }

    return [source, dest].all?{ |klass|
      counts[klass] == 1
    }
  end

  def get_address(klass_symbol)
    record = self.orders.first.send(klass_symbol)
    klass_symbol == :customer ? record.addresses.first : record.address
  end

end
