class RemoveOrderTypeIdAddOrderId < ActiveRecord::Migration[5.0]
  def change
    remove_column :items, :order_type_id, :integer
  end
end
