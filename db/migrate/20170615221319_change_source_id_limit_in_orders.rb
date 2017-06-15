class ChangeSourceIdLimitInOrders < ActiveRecord::Migration[5.0]
  def change
    change_column :orders, :source_order_id, :integer, limit: 8
  end
end
