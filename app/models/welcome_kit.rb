class WelcomeKit < Order
  after_initialize :init
  
  #overwrites parent's version to include set_arrived
  def init
    self.source ||= "Shopify"
    air_tailor_co = Company.where(name: "Air Tailor")
    self.retailer ||= Retailer.find_by(company: air_tailor_co, name: "Air Tailor")
    self.set_arrived
  end
end
