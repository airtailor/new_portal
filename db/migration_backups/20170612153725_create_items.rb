class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :order, index: true
      t.references :order_type, index: true
      t.string :name

      t.timestamps
    end
  end
end
