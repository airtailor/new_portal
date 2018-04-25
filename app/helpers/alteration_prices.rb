module AlterationPrices
  def self.get_price_from_alt_id(alt_id)
    # id => price
    prices = {
      15 => 50.0,
      16 => 15.5,
      25 => 70.0,
      32 => 24.0,
      36 => 24.0,
      37 => 25.0,
      70 => 25.0,
      100 => 25.0,
      159 => 25.0,
      181 => 25.0,
      184 => 25.0,
      186 => 25.0,
      188 => 25.0,
      193 => 80.0,
      204 => 25.0,
      206 => 40.0,
      208 => 15.5,
      209 => 35.0,
      210 => 15.5,
      211 => 30.0,
      212 => 60.0,
      213 => 32.0,
      215 => 15.5,
      216 => 15.5,
      217 => 30.0,
      218 => 15.5,
      219 => 24.0,
      220 => 55.0,
      224 => 55.0
    }
    return prices[alt_id]
  end
end
