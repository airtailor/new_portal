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

  def shippo_address
    {
      name: self.name,
      street1: self.street1,
      street2: self.street2,
      city: self.city,
      state: self.state,
      country: self.country,
      zip: self.zip,
      phone: self.phone,
      email: "air@airtailor.com"
    }
  end
end

