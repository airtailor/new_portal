class UpdateShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :weight, :string
    add_column :shipments, :shipping_label, :string
    add_column :shipments, :tracking_number, :string
  end
end
