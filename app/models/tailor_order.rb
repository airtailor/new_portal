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
    self.source ||= "shoppify"
    self.retailer ||= Retailer.where(company: "Air Tailor").find_by(name: "Air Tailor")
  end
end
