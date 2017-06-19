class TailorOrder < Order
  belongs_to :tailor, class_name: "Tailor", foreign_key: "provider_id", optional: true

  def stores
    [self.retailer, self.tailor]
  end

  # def self.model_name
  #   Order.model_name
  # end
end
