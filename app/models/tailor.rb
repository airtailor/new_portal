class Tailor < Store
  has_many :orders, foreign_key: "provider_id"
  has_many :items, through: :orders
  has_many :alterations, through: :orders
end
