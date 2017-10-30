class UpdateStoreTailorJoins < ActiveRecord::Migration[5.0]
  def up
    add_reference :stores, :address, foreign_key: true, index: true
  end

  def down
    remove_reference :stores, :address
  end
end
