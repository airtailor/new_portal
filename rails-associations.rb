class User 
  belongs_to :store
  has_one :company, through: :store
  has_many :messages
end

class Store
  belongs_to :company
  has_many :users
  has_many :orders
  has_many :messages
  has_and_belongs_to_many :conversations

  has_one :primary_contact, 
    class_name: "User",
    foreign_key: "primary_contact_id"
end

class Company 
  validates :name, presence: true, uniqueness: true

  has_many :stores
  has_one :hq_store, 
    class_name: "Store",
    foreign_key: "hq_store_id"

  has_many :users, through: :stores
end

class Order
  belongs_to :customer  
  has_many :items
  has_many :alterations, through: :items
  has_many :shipments
  has_many :messages

  belongs_to :tailor,
    class_name: "Store",
    foreign_key: "tailor_id" 

  belongs_to :retailer,
    class_name: "Store",
    foreign_key: "retailer_id" 
end

class Customer 
  has_many :orders
  has_many :measurements
end

class Shipment
  belongs_to :order
end

class Item
  belongs_to :order
  has_and_belongs_to_many :alterations
end

class Alteration
  belongs_to :item
  has_and_belongs_to_many :items
end

class Measurement
  belongs_to :customer
end

class Conversation
  has_and_belongs_to_many :stores
  has_many :messages
end

class Message 
  belongs_to :conversation
  belongs_to :user
  belongs_to :store
  belongs_to :order
end

