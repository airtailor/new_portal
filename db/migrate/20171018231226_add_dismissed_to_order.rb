class AddDismissedToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :dismissed, :boolean, default: false
  end
end
