class AddDefaultTailorToRetailers < ActiveRecord::Migration[5.1]
  def up
    add_column :stores, :default_tailor_id, :integer
    add_foreign_key :stores, :stores, column: :default_tailor_id, primary_key: 'id'
    add_index :stores, :default_tailor_id, where: "type = 'Retailer'", using: 'btree'
  end
end
