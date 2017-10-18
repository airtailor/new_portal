class Address < ApplicationRecord
  validates_presence_of :number, :street, :city, :state_province, :zip_code
  validates_presence_of :floor, :unit, if: :is_apartment?

  has_many :customer_addresses
  has_many :customers, through: :customer_address
  has_many :stores

  def is_apartment?
    floor.present? || unit.present?
  end

  def shippo_street_1
    "#{number} #{street}"
  end

  def shippo_street_2
    "#{unit} #{floor}"
  end

  def for_shippo(contact)
    return {
      name: contact.name,
      phone: contact.phone,
      email: contact.email,
      street1: shippo_street_1,
      street2: shippo_street_2,
      city: self.city,
      country: self.country,
      state: self.state,
      zip: self.zip_code
    }
  end

  def convert_street_strings_to_geo_data(location)
    unit =
    {unit: unit, floor: floor, street: street_name}
  end

end
