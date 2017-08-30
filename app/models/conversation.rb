class Conversation < ApplicationRecord
  has_many :messages
  belongs_to :sender, foreign_key: :sender_id, class_name: Store
  belongs_to :recipient, foreign_key: :recipient_id, class_name: Store

  validates :sender_id, uniqueness: { scope: :recipient_id }
  attr_accessor :current_user

  def opposing_sender
    store == recipient ? sender : recipient
  end

  def self.get(sender_id, recipient_id)
    conversation = between(sender_id, recipient_id).first
    return conversation if conversation.present?
    create(sender_id: sender_id, recipient_id: recipient_id)
  end

  scope :between, -> (sender_id, recipient_id) do
    where(sender_id: sender_id, recipient_id: recipient_id).or(
      where(sender_id: recipient_id, recipient_id: sender_id)
    )
  end

  def sender_read
    sender_read = true
    self.messages.each do |message|
      if !message.sender_read 
        sender_read = false
      end
    end
    sender_read
  end

  def recipient_read
    recipient_read = true
    self.messages.each do |message|
      if !message.recipient_read 
        recipient_read = false
      end
    end
    recipient_read
  end

  # def unread_messages_count
  #   if current_user.store.name == "Air Tailor"
  #     self.messages.where(sender_read: false).count
  #   else
  #     conv.messages.where(recipient_read: false).count
  #   end
  # end
end
