class AddPostmatesDeliveryFieldsToShipments < ActiveRecord::Migration[5.0]
  def change
    add_column :shipments, :postmates_delivery_id, :string, index: true
    add_column :shipments, :status, :string, index: true
  end
end
