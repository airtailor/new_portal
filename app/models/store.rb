class Store < ApplicationRecord
  belongs_to :company
  belongs_to :primary_contact, class_name: "User", foreign_key: "primary_contact_id", optional: true
  has_many :users

  def tailor_orders
    self.orders.where(type: "TailorOrder")
  end

  def welcome_kits
    self.orders.where(type: "WelcomeKit")
  end
end
