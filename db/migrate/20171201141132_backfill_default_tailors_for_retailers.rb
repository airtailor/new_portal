class BackfillDefaultTailorsForRetailers < ActiveRecord::Migration[5.1]
  def change
    Retailer.where(default_tailor: nil).update_all(default_tailor_id: Tailor.find(17).id)
  end
end
