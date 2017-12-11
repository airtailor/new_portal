class AddUniqueConstraintToStoreName < ActiveRecord::Migration[5.1]
  def up
    add_index :companies, :name, unique: true, using: :btree
  end

  def down
    remove_index :companies, :name
  end
end
