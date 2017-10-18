class BackfillStoreAddressData < ActiveRecord::Migration[5.0]
  def up
    # DOES NOT WORK. DOES NOT TAKE street2 INTO ACCOUNT SO CANNOT FUNCTION FOR SHOPPO
    # Store.each do |store|
    #   address = store.address.new
    #   address.city = store.city || nil
    #   address.zip_code = store.zip || nil
    #   address.country = store.country || nil
    #
    #   address.convert_street_strings_to_geo_data(store)
    #
    #   store.address.create(params.compact)
    # end
  end

  def down
    # addresses = Store.select(:address_id)
    # Address.where(id: addresses).destroy_all
  end
end

# new table:
#   t.string "street",            null: false
#   t.string "cross_street"
#   t.string "number",            null: false
#   t.string "city",              null: false
#   t.string "zip_code",          null: false
#   t.string "state_province",    null: false
#   t.string "country",           null: false, default: "United States"
#   t.string "country_code",      null: false, default: "US"
#   t.string "floor",             default: nil
#   t.string "unit",              default: nil

# old table:
