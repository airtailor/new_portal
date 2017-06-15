class AddWeightToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :weight, :float
  end
end
