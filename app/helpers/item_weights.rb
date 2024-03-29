module ItemWeights
  def self.get_weight_from_item_type_id(item_type_id)
    # id => weight
    weights = {
      6 => 680,
      7 => 230,
      10 => 340,
      13 => 340,
      12 => 710,
      14 => 150
    }
    return weights[item_type_id]
  end
end
