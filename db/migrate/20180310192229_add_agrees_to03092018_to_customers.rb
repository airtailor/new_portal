class AddAgreesTo03092018ToCustomers < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :agrees_to_03_09_2018, :boolean
    add_column :customers, :agrees_to_03_09_2018, :boolean, :default => false
  end
end
