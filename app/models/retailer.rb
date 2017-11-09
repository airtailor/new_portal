class Retailer < Store
  has_many :orders, inverse_of: :retailer,  foreign_key: "requester_id"

  has_many :items, through: :orders
  has_many :alterations, through: :orders
end
