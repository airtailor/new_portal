class Address < ApplicationRecord
  include StreetAddress
  include AddressConstants

  validates_presence_of :number, :street, :city, :state_province, :zip_code

  has_many :customer_addresses
  has_many :customers, through: :customer_address
  has_many :stores

  has_many :shipments, as: :source
  has_many :shipments, as: :destination

  def shippo_street_1
    "#{number} #{street}"
  end

  def shippo_street_2
    "#{unit} #{floor}"
  end

  def parse_street_name(street, country_code)
    return nil unless country_code.to_sym == :US
    StreetAddress::US.parse(street)
  end

  def extract_street_and_number(params)
    addy_string = "#{params['street']} #{params['city']}, #{params['state_province']} #{params['zip_code']}"
    if parsed_street = parse_street_name(addy_string, self.country_code)
      if parsed_street.street && parsed_street.street_type
        self.street = "#{parsed_street.street} #{parsed_street.street_type}"
      end

      self.number   = parsed_street.number if parsed_street.number
      self.city     = parsed_street.city if parsed_street.city
      self.zip_code = parsed_street.postal_code if parsed_street.postal_code
    else
      self.number = street.scan(/^\d+/)[0] || nil
      if self.number
        self.street = street.split(/^\d+\W+/).reject{|elem| elem == ""}.join("")
      end
    end
  end

  def parse_and_save(params)
    self.assign_attributes(params)

    self.extract_street_and_number(params)
    self.set_state_abbreviation
    self.set_country_and_country_code

    self.save
  end

  def set_state_abbreviation
    state = self.state_province
    return if state.in?(STATE_CODES.values)

    current_state = state
    state = STATE_CODES.get(current_state)
    state ||= current_state

    self.state_province = state
  end

  def set_country_and_country_code
    country_code, country = self.country_code, self.country
    return if country_code.in?(COUNTRY_CODES.values) && country.in?(COUNTRIES.values)

    current_country = country.upcase
    if country.in?(COUNTRIES.values)
      country = country
      country_code = country_codes.get(country)
    elsif country.in?(COUNTRY_CODES.values)
      country = COUNTRY_CODES.get(country)
      country_code = country
    else
      # leave country alone if not found.
      country_code = COUNTRY_CODES.get(current_country)
      country_code ||= current_country
    end

    self.country_code = country_code
    self.country = country
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

end
