class TailorOrder < Order
  def set_default_fields
    super

    stores_with_tailors = [
      "Steven Alan - Tribeca",
      "Frame Denim - SoHo",
      "Rag & Bone - SoHo"
    ]

    if self.retailer.name.in? stores_with_tailors
      self.tailor = Tailor.where(name: "Tailoring NYC").first
    end
  end

end
