class Order < ApplicationRecord
  has_many :items
  has_many :alterations, through: :items
  belongs_to :customer, class_name: "Customer", foreign_key: "customer_id"
  belongs_to :retailer, class_name: "Retailer", foreign_key: "requester_id"
  belongs_to :tailor, class_name: "Tailor", foreign_key: "provider_id",
    optional: true
  has_one :outgoing_shipment, class_name: "OutgoingShipment",
    foreign_key: "order_id"
  has_one :incoming_shipment, class_name: "IncomingShipment",
    foreign_key: "order_id"

  validates :retailer, presence: true
  after_initialize :init
  after_create :send_text_to_customer

  # This method is overwritten so that the 'type' attribute will
  # be rendered in the json response
  def serializable_hash options=nil
    super.merge "type" => type
  end

  def shipments
    [
      self.outgoing_shipment,
      self.incoming_shipment
    ]
  end

  def init
    self.source ||= "Shopify"
    air_tailor_co = Company.where(name: "Air Tailor")
    self.retailer ||= Retailer
      .find_by(company: air_tailor_co, name: "Air Tailor")

    if (self.retailer.name == "Steven Alan - Tribeca" || self.retailer.name == "Frame Denim - SoHo")
      self.tailor = Tailor.find_by(name: "Tailoring NYC")
    end

  end

  def send_text_to_customer
    message = "Hey there, Air Tailor here : ) Thanks for letting us " +
      "make your clothes look great! We'll keep you updated on their " + 
      "status. Text any time if you have questions."

    SendSonar.message_customer(text: message, to: self.customer.phone)
  end

  def arrived=(boolean)
    super(boolean)
    set_arrival_date
    set_due_date
  end

  def fulfilled=(boolean)
    super(boolean)
    set_fulfilled_date
  end

  def self.on_time
    self.where(late: false)
  end

  def self.late
    self.where(late: true)
  end

  def self.find_or_create(order_info, customer, source = "Shopify")
    self.find_or_create_by(source_order_id: order_info["id"], source: source, customer: customer) do |order|
      order.total = order_info["total_price"]
      order.subtotal = order_info["subtotal_price"]
      order.discount = order_info["total_discounts"]
      order.requester_notes = order_info["note"]
      order.weight = order_info["total_weight"]
    end
  end

  def set_fulfilled
    self.fulfilled = true
    set_fulfilled_date
  end

  def grab_items_by_type(item_name)
    self.items.select do |item|
      item.item_type.name == item_name
    end
  end

  def set_arrived
    self.update_attributes(arrived: true)
    set_arrival_date
    set_due_date
  end

  def assigned?
    self.tailor != nil
  end

  def self.assigned
    self.where("orders.provider_id IS NOT NULL")
  end

  def self.needs_assigned
    self.where("orders.provider_id IS NULL")
  end

  scope :unfulfilled, -> { where(fulfilled: false)}

  scope :active, -> { where(arrived: true).where(fulfilled: false) }

  scope :by_due_date, -> { order(:due_date) }

  def alterations_count
    self.items.reduce(0) do |prev, curr|
      prev += AlterationItem.where(item: curr).count
    end
  end

  private

  def set_arrival_date
    self.update_attributes(arrival_date: DateTime.now.in_time_zone.midnight)
  end

  def set_due_date
    self.update_attributes(due_date: 6.days.from_now.in_time_zone.midnight)
  end

  def set_fulfilled_date
    self.update_attributes(fulfilled_date: DateTime.now)
  end
end
