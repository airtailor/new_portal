class Order < ApplicationRecord
  validates :retailer, presence: true
  belongs_to :customer, class_name: "Customer", foreign_key: "customer_id"

  belongs_to :retailer, class_name: "Retailer", foreign_key: "requester_id"
  has_many :items
  has_many :alterations, through: :items

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
