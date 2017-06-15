class Order < ApplicationRecord
  has_many :items
  has_many :alterations, through: :items
  belongs_to :customer, class_name: "Customer", foreign_key: "customer_id"
  belongs_to :retailer, class_name: "Retailer", foreign_key: "requester_id"

  validates :retailer, presence: true
  after_initialize :init

  def init
    self.source ||= "Shopify"
    air_tailor_co = Company.where(name: "Air Tailor")
    self.retailer ||= Retailer.find_by(company: air_tailor_co, name: "Air Tailor")
  end

  def self.find_or_create(order_info, customer, source = nil)
    self.find_or_create_by(source_order_id: order_info["id"], source: source) do |order|
      order.customer = customer
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
    self.arrived = true
    set_arrival_date
    set_due_date
  end

  private

  def set_arrival_date
    self.arrival_date = DateTime.now.in_time_zone.midnight
  end

  def set_due_date
    self.due_date = 5.days.from_now.in_time_zone.midnight
  end

  def set_fulfilled_date
    self.fulfilled_date = DateTime.now
  end

end
