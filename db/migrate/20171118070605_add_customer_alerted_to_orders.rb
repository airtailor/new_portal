class AddCustomerAlertedToOrders < ActiveRecord::Migration[5.0]
  def up
    add_column :orders, :customer_alerted, :boolean, default: false
  end

  def down
    remove_column :orders, :customer_alerted
  end
end
