class BackfillOldAddresses
  require 'street_address'

  def self.run
    build_address_table(Store)
    build_address_table(Customer)
  end

  def self.build_address_table(klass)
    countries, country_codes = Address::COUNTRIES, Address::COUNTRY_CODES
    states, state_codes = Address::STATES, Address::STATE_CODES

    klass.all.each do |geo_obj|
      skip_me = [:street1, :city, :state, :zip, :country].any? { |a|
        geo_obj.send(a).nil?
      }
      next if skip_me

      if geo_obj.respond_to?(:address)
        address = Address.new
        geo_obj.address = address
      elsif geo_obj.respond_to?(:addresses)
        address = Address.new
        add_at_end = true
      end

      country = geo_obj.country.upcase
      if country.in?(countries.values)
        address.country = country
        address.country_code = country_codes.get(country)
      elsif country.in?(country_codes.values)
        address.country = country_codes.get(country)
        address.country_code = country
      else
        address.country = geo_obj.country
        # if we got a full string for the country, retrieve the code
        address.country_code = country_codes.get(geo_obj.country)
        # if that doesn't work, just add the code to the DB
        address.country_code ||= geo_obj.country
      end

      state = geo_obj.state.upcase
      if state.in?(states.values)
        address.state_province = state_codes.get(state)
      elsif state.in?(state_codes.values)
        address.state_province = state
      end

      byebug if !address.state_province || !address.country

      address.floor, address.unit = nil, nil
      address.street_two = geo_obj.street2

      addy_string = "#{geo_obj.street1} #{geo_obj.city}, #{geo_obj.state} #{geo_obj.zip}"
      parsed_street = parse_street_name(addy_string, address.country_code)

      if parsed_street
        address.number = parsed_street.number
        address.street = "#{parsed_street.street} #{parsed_street.street_type}"
        address.city, address.zip_code = parsed_street.city, parsed_street.postal_code
      else
        address.number = geo_obj.street1.scan(/^\d+/)[0] || nil
        if address.number
          just_street = geo_obj.street1.split(/^\d+\W+/).reject{|elem| elem == ""}
          address.street = just_street.join(" ")
        end
        address.city = geo_obj.city
        address.zip_code = geo_obj.zip_code
      end

      geo_obj.phone ||= "630 235 2554"

      address.save

      geo_obj.addresses << address if add_at_end
      geo_obj.save
    end
  end

  def self.parse_street_name(street, country_code)
    return nil unless country_code.to_sym == :US
    StreetAddress::US.parse(street)
  end

end

# BackfillOldAddresses.run
