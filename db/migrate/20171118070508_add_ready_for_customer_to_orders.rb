class AddReadyForCustomerToOrders < ActiveRecord::Migration[5.0]
  def up
    add_column :orders, :ready_for_customer, :boolean, default: false
  end

  def down
    remove_column :orders, :ready_for_customer
  end
end
