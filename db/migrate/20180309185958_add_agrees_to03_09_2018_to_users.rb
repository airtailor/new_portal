class AddAgreesTo03092018ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :agrees_to_03_09_2018, :boolean, :default => false
  end
end
