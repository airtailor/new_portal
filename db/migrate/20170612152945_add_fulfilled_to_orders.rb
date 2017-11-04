class AddFulfilledToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :fulfilled_date, :datetime
  end
end
