class AddOrderIdToShipments < ActiveRecord::Migration[5.0]
  def change
    add_reference :shipments, :order, foreign_key: true
  end
end
