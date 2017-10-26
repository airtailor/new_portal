class WelcomeKit < Order
  after_initialize :init

  #overwrites parent's version to include set_arrived
  def init
    self.source ||= "Shopify"
    self.weight = 28
    air_tailor_co = Company.where(name: "Air Tailor")
    self.retailer ||= Retailer.find_by(company: air_tailor_co, name: "Air Tailor")
    # this is broken. do we need to say  welcome kits have arrived?
    #self.arrived = true
  end
end
