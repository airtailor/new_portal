class CreateCustomerAddress < ActiveRecord::Migration[5.0]
  def up
    # join them together
    create_table :customer_addresses do |t|
      t.references :customer
      t.references :address
      t.timestamps
    end

    # make sure we're indexing unique on customer_id and address_id.
    add_index :customer_addresses, [:address_id, :customer_id], unique: true
  end

  def down
    remove_index :customer_addresses, [:address_id, :customer_id]
    drop_table :customer_addresses
  end
end
