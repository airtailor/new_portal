class Retailer < Store
  has_many :orders, inverse_of: :retailer,  foreign_key: "requester_id"

  has_many :items, through: :orders
  has_many :alterations, through: :orders

  # Retailers:
  # 1 - Ohio (Air Tailor)
  # 3 - New York
  # 2 - New York
  # 5 - New York
  #
  # Tailors:
  # 4 - New York
  # 6 - San Francisco
  # 7 - Culver City
  # 8 - Austin
  # 9 - Chicago

  TAILOR_IDS = { 1 => 4, 2 => 4, 3 => 4, 5 => 4 }

  def default_tailor
    return Tailor.find(TAILOR_IDS[self.id])
  end
end
