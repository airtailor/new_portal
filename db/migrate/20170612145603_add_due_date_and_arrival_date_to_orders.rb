class AddDueDateAndArrivalDateToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :due_date, :datetime
    add_column :orders, :arrival_date, :datetime
  end
end
