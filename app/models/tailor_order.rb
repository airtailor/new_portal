class TailorOrder < Order
  validates :tailor, presence: true
  after_initialize :init
  belongs_to :customer, class_name: "Customer", foreign_key: "customer_id"

  belongs_to :tailor,
    class_name: "Tailor",
    foreign_key: "provider_id"

  def stores
    [self.retailer, self.tailor]
  end

  def init
    self.source ||= "Shopify"
    self.retailer ||= Retailer.where(company: "Air Tailor").find_by(name: "Air Tailor")
  end

  def set_arrived
    self.arrived = true
    set_arrival_date
    set_due_date
  end

  def set_fulfilled 
    self.fulfilled = true 
    set_fulfilled_date
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
