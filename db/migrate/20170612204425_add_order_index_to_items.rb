class AddOrderIndexToItems < ActiveRecord::Migration[5.0]
  def change
    add_index :items, :order_id
  end
end
