class RemoveReadyForCustomerFromOrders < ActiveRecord::Migration[5.0]
  def up
    remove_column :orders, :ready_for_customer
  end

  def down
    add_column :orders, :ready_for_customer, :boolean, default: false
  end

end
