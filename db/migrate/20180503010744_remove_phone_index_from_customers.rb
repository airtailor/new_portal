class RemovePhoneIndexFromCustomers < ActiveRecord::Migration[5.1]
  def change
    remove_index :customers, :phone
  end
end
