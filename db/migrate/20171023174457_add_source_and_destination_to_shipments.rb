class AddSourceAndDestinationToShipments < ActiveRecord::Migration[5.0]
  def up
    [:source, :destination].each do |column|
      add_reference :shipments, column, polymorphic: true, index: true
    end
  end

  def down
    [:source, :destination].each do |column|
      remove_reference :shipments, column, polymorphic: true, index: true
    end
  end
end
