class Retailer < Store
  has_many :orders, inverse_of: :retailer,  foreign_key: "requester_id"
  has_many :items, through: :orders
  has_many :alterations, through: :orders

  TAILOR_IDS = {
    2 => 17, # Steven Alan - Tribeca => # About the Stitch
    3 => 17,  # Frame Denim - SoHo => # About the Stitch
    5 => 17,  # J.Crew - 5th Ave => # About the Stitch
    11 => 17, # Wolf & Badger => # About the Stitch
    12 => 17, # MOUSSY => # About the Stitch
    13 => 17, # Opening Ceremony - Howard St. => # About the Stitch
    18 => 17, # Steven Alan - UWS => # About the Stitch
    19 => 17, # Steven Alan - Chelsea => # About the Stitch
    20 => 17 # Steven Alan - Brooklyn => # About the Stitch
  }

  def default_tailor
    return Tailor.where(id: TAILOR_IDS[self.id]).first
  end

  def address_type_string
    "retailer"
  end
end
