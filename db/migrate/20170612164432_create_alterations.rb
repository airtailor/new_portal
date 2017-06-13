class CreateAlterations < ActiveRecord::Migration[5.0]
  def change
    create_table :alterations do |t|
      t.integer :alteration_type, null: false
      t.timestamps
    end
  end
end
