class Tailor < Store
  has_many :orders, foreign_key: "provider_id"
  has_many :items, through: :orders
  has_many :alterations, through: :orders


  def late_orders
    self.orders.late(true)
  end

  def current_orders
    self.orders.active
  end

  def new_orders
    self.orders.where(arrived: false)
  end
end
