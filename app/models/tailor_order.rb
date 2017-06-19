class TailorOrder < Order
  def stores
    [self.retailer, self.tailor]
  end
end
