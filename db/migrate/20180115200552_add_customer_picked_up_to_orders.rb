class AddCustomerPickedUpToOrders < ActiveRecord::Migration[5.1]
  def change
    add_column :orders, :customer_picked_up, :boolean, :default => false
  end
end
