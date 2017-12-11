class StevenAlanCustomersAreAllAlerted < ActiveRecord::Migration[5.1]
  # if we allow a down here, we'll be wiping data from after this merge
  def change
    store = Retailer.where(id: 2).or(Retailer.where(name: "Steven Alan - Tribeca")).first
    store.orders.where(fulfilled: true).update_all(customer_alerted: true)
  end
end
