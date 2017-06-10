class WelcomeKit < Order

  has_one :customer, class_name: "Customer", foreign_key: "customer_id"

  after_initialize :init

  def init
    self.retailer ||= Retailer.find_by(name: "Air Tailor")
    self.source ||= "Shoppify"
  end
end
