class Store < ApplicationRecord

  belongs_to :company
  belongs_to :primary_contact, class_name: "User", foreign_key: "primary_contact_id", optional: true
  belongs_to :address

  has_many :items, through: :orders
  has_many :alterations, through: :orders

  has_many :orders
  has_many :users
  has_many :messages

  has_many :conversations, foreign_key: :sender_id
  has_many :conversations, foreign_key: :recipient_id

  validates :name, :phone, presence: true

  after_create :initiate_conversation

  def set_address(params)
    self.build_address.parse_and_save(params) if Address.where(params).blank?
  end

  def update_address(params)
    address = self.address
    address ||= Address.where(params).first

    if address
      self.address = address.parse_and_save(params)
    else
      self.build_address.parse_and_save(params)
    end
  end

  def tailor_orders
    self.orders.by_type("TailorOrder")
  end

  def welcome_kits
    self.orders.by_type("WelcomeKit")
  end

  def shippo_address
    return address.for_shippo if address
    return nil
  end

  def open_orders
    self.orders.open_orders
  end

  def retailer_orders
    self.orders.retailer_view
  end

  def late_orders_count
    open_orders.late(true).count
  end

  def active_orders_count
    if self.type == "Retailer"
      self.open_orders.count
    elsif self.type == "Tailor"
      self.orders.active.count
    end
  end

  def arrived_orders_count
    self.orders.fulfilled(false).arrived(true).count
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
    if self.name != "Air Tailor"
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
