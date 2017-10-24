class AddTypeToAddresses < ActiveRecord::Migration[5.0]
  def up
    add_column :addresses, :address_type, :string

    customer_ids = CustomerAddress.select(:address_id).uniq.pluck(:address_id)
    Address.where(id: customer_ids).update_all(type: 'customer')

    retailer_ids = Retailer.select(:address_id).uniq.pluck(:address_id)
    Address.where(id: retailer_ids).update_all(type: 'retailer')

    tailor_ids = Tailor.select(:address_id).uniq.pluck(:address_id)
    Address.where(id: tailor_ids).update_all(type: 'tailor')

  end

  def down
    remove_column :addresses, :address_type
  end
end
