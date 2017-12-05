class Address < ApplicationRecord
  include StreetAddress
  include AddressConstants
  include TypeConstants

  validates_presence_of :number, :street, :city, :state_province,
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
    self.extract_street_and_number(params)

    self.save
  end

  def set_address_type(string)
    self.address_type = string
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

  def parse_street_name(street, country_code)
    return nil unless country_code.to_sym == :US
    StreetAddress::US.parse(street)
  end

  # NOTE: street_two does not get touched by this method. Ask nialbima.
  def extract_street_and_number(unparsed_params)
    addy_string = "#{unparsed_params['street']} #{unparsed_params['city']}, #{unparsed_params['state_province']} #{unparsed_params['zip_code']}"
    if parsed_street = parse_street_name(addy_string, self.country_code)
      if parsed_street.street && parsed_street.street_type
        self.street = [
          parsed_street.prefix,
          parsed_street.street,
          parsed_street.street_type,
          parsed_street.suffix
        ].compact.join(" ")
      end

      self.number   = parsed_street.number
      self.city     = parsed_street.city
      self.zip_code = parsed_street.postal_code
      self.unit     = parsed_street.unit
    else
      self.number = street.scan(/^\d+/)[0] || nil
      if self.number
        self.street = street.split(/^\d+\W+/).reject{|elem| elem == ""}.join("")
      end
      self.zip_code = unparsed_params.zip_code
      self.city = unparsed_params.city
      self.unit = unparsed_params.unit
    end
  end

  def postmates_address
    "#{number} #{street}, #{city}, #{state_province}"
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

  def shippo_address
    contact = self.get_contact
    return {
      :name => contact.name,
      :street1 => "#{self.number} #{self.street}",
      :street2 => "#{self.unit} #{self.floor} #{self.street_two}",
      :city => self.city,
      :country => self.country,
      :state => self.state_province,
      :zip => self.zip_code,
      :phone => contact.try(:phone),
      :email => contact.try(:email)
    }
  end
end
