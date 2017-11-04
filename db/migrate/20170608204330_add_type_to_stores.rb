class AddTypeToStores < ActiveRecord::Migration[5.0]
  def change
    add_column :stores, :type, :string
  end
end
