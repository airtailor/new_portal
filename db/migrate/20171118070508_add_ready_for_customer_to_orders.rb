class AddReadyForCustomerToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :ready_for_customer, :boolean, default: false
  end
end
