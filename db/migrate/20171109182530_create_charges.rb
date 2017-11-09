class CreateCharges < ActiveRecord::Migration[5.0]
  def change
    create_table :charges do |t|
      t.integer :amount
      t.string :stripe_id

      t.references :chargable, polymorphic: true, index: true
      t.references :payable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
