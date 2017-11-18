class AddCustomerAlertedToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :customer_alerted, :boolean, default: false
  end
end
