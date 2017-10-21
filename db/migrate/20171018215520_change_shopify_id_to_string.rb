class ChangeShopifyIdToString < ActiveRecord::Migration[5.0]
  def change
    change_column :customers, :shopify_id, :string
  end
end
