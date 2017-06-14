class TailorOrder < Order
  validates :tailor, presence: true

  after_initialize :init
  belongs_to :tailor, class_name: "Tailor", foreign_key: "provider_id", optional: true

  def stores
    [self.retailer, self.tailor]
  end

  def init
    self.source ||= "Shopify"
  end
end
