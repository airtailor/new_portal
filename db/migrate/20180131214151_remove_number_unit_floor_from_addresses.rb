class RemoveNumberUnitFloorFromAddresses < ActiveRecord::Migration[5.1]
  def change
    remove_column :addresses, :number
    remove_column :addresses, :unit
    remove_column :addresses, :floor
  end
end
