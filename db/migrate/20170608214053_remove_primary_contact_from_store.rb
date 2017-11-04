class RemovePrimaryContactFromStore < ActiveRecord::Migration[5.0]
  def change
    remove_index :stores, column: :primary_contact_id
  end
end
