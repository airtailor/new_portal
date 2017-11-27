class AddIndicesToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_index :customers, :email, unique: true, using: :btree
    add_index :customers, :phone, unique: true, using: :btree
    add_index :customers, [:first_name, :last_name], using: :btree
  end
end
