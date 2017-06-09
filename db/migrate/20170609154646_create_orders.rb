class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.string :source, null: false
      t.integer :source_order_id 
      t.integer :customer_id, null: false
      t.string :type
      t.boolean :fulfilled, default: false
      t.timestamps :fullfilled_date
      t.boolean :arrived, default: false
      t.timestamps :arrived_date
      t.timestamps :due_date
      t.boolean :late, default: false
      t.text :requester_notes
      t.text :provider_notes
      t.float :subtotal, null: false
      t.float :total, null: false
      t.float :discount
      t.references :provider, references: :tailors, index: true
      t.references :requester, references: :retailers, index: true
      t.timestamps
    end
  end
end
