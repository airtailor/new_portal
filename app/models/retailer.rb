class Retailer < Store
  has_many :orders, inverse_of: :retailer,  foreign_key: "requester_id"
  has_many :items, through: :orders
  has_many :alterations, through: :orders

  TAILOR_IDS = {
    2 => 4, # Steven Alan - Tribeca => # Tailoring NYC
    3 => 4,  # Frame Denim - SoHo => # Tailoring NYC
    5 => 4,  # J.Crew - 5th Ave => # Tailoring NYC
    11 => 4, # Wolf & Badger => # Tailoring NYC
    12 => 4, # MOUSSY => # Tailoring NYC
    13 => 4 # Opening Ceremony - Howard St. => # Tailoring NYC
  }

  def default_tailor
    return Tailor.where(id: TAILOR_IDS[self.id]).first
  end

  def address_type_string
    "retailer"
  end
end
