class BackfillOldAddresses < ActiveRecord::Migration[5.0]

  def up
    if !"BackfillStoreAndCustomerAddresses".constantize
      raise ActiveRecord::IrreversibleMigration
    else
      BackfillStoreAndCustomerAddresses.run
    end
  end

  def down
    Address.where(id: Store.select(:address_id)).destroy_all
    Address.where(id: CustomerAddress.select(:address_id)).destroy_all
    CustomerAddress.destroy_all
  end

end
