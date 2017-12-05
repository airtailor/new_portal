class Shipment < ApplicationRecord
  include ShipmentConstants
  include DeliveryHelper

  belongs_to :source, inverse_of: :shipments, polymorphic: true
  belongs_to :destination, inverse_of: :shipments, polymorphic: true

  has_many :shipment_orders
  has_many :orders, through: :shipment_orders, inverse_of: :shipments
  has_many :customers, through: :orders

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

  def handle_error(e)
    @error_obj = e
    error_class = e.class
    if error_class == Postmates::BadRequest
      self.postmates_error
      self.undeliverable_area_error
    else
      self.unknown_shipment_error
    end
  end

  def unknown_shipment_error
    self.errors.add(:unknown_delivery_error, message: @error_obj.as_json)
  end

  def postmates_error
    self.errors.add(:postmates, message: 'Postmates delivery failed.' )
  end

  def undeliverable_area_error
    self.errors.add(:undeliverable_area, message: @error_obj.as_json.gsub("400 ", ""))
  end

  def deliver
    case self.delivery_type
    when MAIL
      if is_mail_shipment? && needs_label
        delivery = create_label(self)
        self.shipping_label  = delivery.try(:label_url)
        self.tracking_number = delivery.try(:tracking_number)
      end

    when MESSENGER
      if is_messenger_shipment? && needs_messenger
        delivery = request_messenger
        self.postmates_delivery_id = delivery.try(:id)
        self.status = delivery.try(:status)
      end
    end
  end

  def text_all_shipment_customers
    orders.map(&:text_order_customers)
  end

  def set_delivery_method(action)
    orders = self.orders
    source_model, dest_model = parse_src_dest(action)
    if delivery_can_be_executed?(source_model, dest_model, orders)
      self.source = get_address(source_model)
      if orders.any?{|o| o.ship_to_store} && dest_model == :customer
        self.destination = get_address(:retailer)
      else
        self.destination = get_address(dest_model)
      end
    end
  end

  private

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

  # NOTE: we need this because of the differing wys in which customer/tailor/
  # retailer relate to the address table.
  def get_address(klass_symbol)
    record = self.orders.first.send(klass_symbol)
    if klass_symbol == :customer
      return customer_address_object = record.addresses.first || record
    else
      return record.address
    end
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

  def needs_messenger
    !self.postmates_delivery_id || !self.status
  end

end
