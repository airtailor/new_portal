class RemoveAlterationType < ActiveRecord::Migration[5.0]
  def change
    drop_table :alteration_types
  end
end
