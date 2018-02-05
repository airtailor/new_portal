class Address < ApplicationRecord
  include StreetAddress
  include AddressConstants
  include TypeConstants

  validates_presence_of :street, :city, :state_province,
    :zip_code, :country, :country_code

  has_many :shipments, inverse_of: :address, as: :source
  has_many :shipments, inverse_of: :address, as: :destination

  has_many :customer_addresses
  has_many :customers, through: :customer_addresses
  has_many :stores

  def parse_and_save(params, model)
    self.assign_attributes(params)

    self.set_address_type(model)
    self.set_country_and_country_code
    self.set_state_abbreviation

    self.save
  end

  def get_contact
    case self.address_type
    when CUSTOMER
      # NOTE: without the UI, this will always work.
      # When we implement the UI for multi-customer shipping, this'll break immediately.
      return self.customers.first
    when TAILOR
      return self.stores.where(type: "Tailor").first
    when RETAILER
      return self.stores.where(type: "Retailer").first
    end
  end

  def postmates_address
    "#{street}, #{city}, #{state_province}"
  end

  def shippo_address
    contact = self.get_contact

    if contact.class.name == "Tailor"
      name = "Air Tailor"
    else
      name = contact.name
    end

    return {
      :name => name,
      :street1 => "#{self.street}",
      :street2 => "#{self.street_two}",
      :city => self.city,
      :country => self.country,
      :state => self.state_province,
      :zip => self.zip_code,
      :phone => contact.try(:phone),
      :email => contact.try(:email)
    }
  end

  private

  def set_address_type(string)
    self.address_type = string
  end

  def set_country_and_country_code
    country_code, country = self.country_code, self.country
    return if country_code.in?(COUNTRY_CODES.values) && country.in?(COUNTRIES.values)

    if country.in?(COUNTRIES.values)
      country = country
      country_code = COUNTRY_CODES.get(country)
    elsif country.in?(COUNTRY_CODES.values)
      country_code = country
      country = COUNTRIES.get(country)
    else
      # leave country alone if not found.
      country_code = COUNTRY_CODES.get(country)
      country_code ||= country
    end

    self.country_code = country_code
    self.country = country
  end

  def set_state_abbreviation
    state = self.state_province
    return if state.in?(STATE_CODES.values)

    current_state = state
    state = STATE_CODES.get(current_state)
    state ||= current_state

    self.state_province = state
  end
end
