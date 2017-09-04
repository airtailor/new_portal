class Store < ApplicationRecord
  belongs_to :company
  belongs_to :primary_contact, class_name: "User", foreign_key: "primary_contact_id", optional: true
  has_many :users

  has_many :messages
  has_many :conversations, foreign_key: :sender_id
  has_many :conversations, foreign_key: :recipient_id

  after_create :initiate_conversation

  def tailor_orders
    self.orders.where(type: "TailorOrder")
  end

  def welcome_kits
    self.orders.where(type: "WelcomeKit")
  end

  def shippo_address
    # removing email may break shippo
    {
      name: self.name,
      street1: self.street1,
      street2: self.street2,
      city: self.city,
      state: self.state,
      country: self.country,
      zip: self.zip,
      phone: self.phone
      # ,
      # email: "air@airtailor.com"
    }
  end

  def open_orders
    self.orders.order(:due_date).unfulfilled
  end

  def late_orders_count
    self.orders.late.count
  end

  def active_orders_count
    self.orders.active.count
  end

  def transit_to_tailor_count
    self.orders.where(arrived: false).count
  end

  def unread_messages_count
    list = []
    if self.name == "Air Tailor"
      list = self.conversations.inject(0) do |prev, conv|
        prev += conv.messages.where(sender_read: false).count
      end
    else
      list = self.conversations.inject(0) do |prev, conv|
        prev += conv.messages.where(recipient_read: false).count
      end
    end
    list
  end

  def initiate_conversation
    if self.name == "Air Tailor"
      # do nothing
    else
      air_tailor = Store.where(name: "Air Tailor").first
      convo = Conversation.create(sender: air_tailor, recipient: self)

      Message.create(
        store: air_tailor,
        conversation: convo,
        body: "Hi, Welcome to Air Tailor! Just message us here if you have any questions",
        sender_read: true
      )
    end
  end

end

