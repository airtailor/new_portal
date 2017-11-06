class AddStripeIdToStores < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :stripe_id, :string
  end
end
