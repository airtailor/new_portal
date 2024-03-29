class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.text :body
      t.references :store, foreign_key: true
      t.references :conversation, foreign_key: true

      t.timestamps
    end
  end
end
