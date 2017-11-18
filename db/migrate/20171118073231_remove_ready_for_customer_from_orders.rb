class RemoveReadyForCustomerFromOrders < ActiveRecord::Migration[5.0]
  def change
    remove_column :orders, :ready_for_customer
  end
end
