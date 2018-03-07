module AlterationPrices
  def self.get_price_from_alt_id(alt_id)
    # id => price
    prices = {
      16 => 15.5,
      36 => 24.0,
      208 => 15.5,
      210 => 15.5,
      219 => 24.0,
      217 => 30,
      218 => 15.5,
      211 => 30,
      215 => 15.0,
      216 => 15.0
    }
    return prices[alt_id]
  end
end
