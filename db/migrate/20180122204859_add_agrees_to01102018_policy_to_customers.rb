class AddAgreesTo01102018PolicyToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :agrees_to_01_10_2018, :boolean, :default => false
  end
end
