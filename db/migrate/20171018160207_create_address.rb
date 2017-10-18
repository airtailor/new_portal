class CreateAddress < ActiveRecord::Migration[5.0]
  def up
    create_table :addresses do |t|
      t.string "street",            null: false
      t.string "cross_street"
      t.string "number",            null: false
      t.string "city",              null: false
      t.string "zip_code",          null: false
      t.string "state_province",    null: false
      t.string "country",           null: false, default: "United States"
      t.string "country_code",      null: false, default: "US"
      t.string "floor",             default: nil
      t.string "unit",              default: nil

      t.timestamps
    end

    add_index :addresses, :street, using: 'btree'
    add_index :addresses, :number, using: 'btree'
    add_index :addresses, :city, using: 'btree'
    add_index :addresses, :state_province, using: 'btree'
    add_index :addresses, :zip_code, using: 'btree'

    # these indices are for letting the compound index take advantage
    add_index :addresses, :floor, using: 'btree'
    add_index :addresses, :unit, using: 'btree'

    # we can use a BST index to prevent duplicate addresses, but it needs to be
    # done carefully. We won't get a ton of updates (these won't change that rapidly),
    # but we'll get a TON of creates (every store, eveyr user).

    # I thnk this also means that if we need to search by a full address, we can
    # make it fast if we set up our methods to take full advantage.

    add_index(
      :addresses,
      [ :country, :zip_code, :city, :street, :number, :floor, :unit ],
      {
        unique: true,
        using: 'btree',
        name: 'by_compound_location'
      }
    )
  end

  def down
    remove_index(:addresses, {:name=>"by_compound_location"})
    remove_index(:addresses, {:column=>:unit})
    remove_index(:addresses, {:column=>:floor})
    remove_index(:addresses, {:column=>:zip_code})
    remove_index(:addresses, {:column=>:state_province})
    remove_index(:addresses, {:column=>:city})
    remove_index(:addresses, {:column=>:number})
    remove_index(:addresses, {:column=>:street})

    drop_table :addresses
  end
end
