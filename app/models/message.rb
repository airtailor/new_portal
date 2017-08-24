class Message < ApplicationRecord
  belongs_to :store
  belongs_to :conversation
  belongs_to :order, optional: true

  before_save :default_values

  validates_presence_of :body, :conversation_id, :store_id

  def default_values
    self.sender_read ||= false
    self.recipient_read ||= false
  end
end
