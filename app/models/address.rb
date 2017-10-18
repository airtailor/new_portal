class Address < ApplicationRecord
  validates_presence_of :number, :street, :city, :state_province, :zip_code
  validates_presence_of :floor, :unit, if: :is_apartment?

  has_many :customer_addresses
  has_many :customers, through: :customer_address

  has_many :stores

  def is_apartment?
    floor.present? && unit.present?
  end

  def for_shippo(contact)
    return {
      name: contact.name,
      phone: contact.phone,
      email: contact.email,
      street1: self.street,
      street2: self.cross_street,
      city: self.city,
      country: self.country,
      state: self.state,
      zip: self.zip_code
    }
  end

end
