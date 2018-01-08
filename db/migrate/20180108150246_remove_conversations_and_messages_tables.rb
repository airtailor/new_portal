class RemoveConversationsAndMessagesTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :messages
    drop_table :conversations
  end
end
