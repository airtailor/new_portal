class CreateShipments < ActiveRecord::Migration[5.0]
  def change
    create_table :shipments do |t|
      t.integer :order_id
      t.string :shipment
      t.string :type
      t.timestamps null: false
    end
  end
end
