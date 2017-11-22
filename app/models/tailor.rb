class Tailor < Store
  has_many :orders, inverse_of: :tailor, foreign_key: "provider_id"

  def late_orders
    self.orders.late(true)
  end

  def current_orders
    self.orders.active
  end

  def new_orders
    self.orders.where(arrived: false)
  end

  def address_type_string
    "tailor"
  end
end
