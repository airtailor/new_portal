class CreateAlterationsItemsJoinTable < ActiveRecord::Migration[5.0]
  create_table :alterations_items, id: false do |t|
    t.integer :alteration_id
    t.integer :item_id
  end
end
