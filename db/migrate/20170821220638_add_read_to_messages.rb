class AddReadToMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :messages, :sender_read, :boolean
    add_column :messages, :recipient_read, :boolean
    add_reference :messages, :order, foreign_key: true
  end
end
