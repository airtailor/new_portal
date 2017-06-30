class Tailor < Store
  has_many :orders, foreign_key: "provider_id"
  has_many :items, through: :orders
  has_many :alterations, through: :orders


  def late_orders
    self.orders.where(late: true)
  end

  def current_orders
    self.orders.where(arrived: true).where(fulfilled: false)
  end

  def new_orders
    self.orders.where(arrived: false)
  end
end
