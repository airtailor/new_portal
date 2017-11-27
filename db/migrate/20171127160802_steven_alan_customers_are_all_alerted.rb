class StevenAlanCustomersAreAllAlerted < ActiveRecord::Migration[5.1]
  def up
    store = Retailer.where(id: 2).or(Retailer.where(name: "Steven Alan - Tribeca")).first
    store.orders.where(fulfilled: true).update_all(customer_alerted: true)
  end

  def down
    # if we allow a down here, we'll wipe data from after this merge.
    raise ActiveRecord::IrreversibleMigration
  end
end
