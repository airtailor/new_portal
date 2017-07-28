class AddTypeToShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :type, :string
  end
end
