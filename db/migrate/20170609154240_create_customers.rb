class CreateCustomers < ActiveRecord::Migration[5.0]
  def change
    create_table :customers do |t|
      t.integer :shopify_id
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :street1, null: false
      t.string :street2, null: false
      t.string :city, null: false
      t.string :state, null: false
      t.string :country, null: false
      t.string :zip, null: false
      t.timestamps
    end
  end
end
