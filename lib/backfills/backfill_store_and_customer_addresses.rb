def reset_queries
  Store.update_all(address_id: nil)
  CustomerAddress.destroy_all
  Address.destroy_all
end

class BackfillStoreAndCustomerAddresses
  require 'street_address'

  def self.run
    build_address_table(Store)
    build_address_table(Customer)
  end

  def self.build_address_table(klass)
    countries, country_codes = Address::COUNTRIES, Address::COUNTRY_CODES
    states, state_codes = Address::STATES, Address::STATE_CODES

    if klass == Customer
      build_through_join = true
    end

    klass.all.each do |geo_obj|
      next if skip_obj(geo_obj)

      if build_through_join
        address = geo_obj.addresses.build
      else
        address = geo_obj.build_address
      end

      address.country = countries.get(geo_obj.country)
      address.country ||= geo_obj.country if country_codes.get(geo_obj.country)
      address.country ||= "UNITED STATES"

      address.country_code = country_codes.get(address.country)
      address.country_code ||= "US"

      address.state_province = geo_obj.state if states.get(geo_obj.state)
      address.state_province ||= state_codes.get(geo_obj.state)

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
        address.zip_code = geo_obj.zip
      end

      geo_obj.phone ||= "630 235 2554"

      address.save
      geo_obj.save
    end
  end

  def self.skip_obj(obj)
    [:street1, :city, :state, :zip, :country].any? { |a|
      obj.send(a).nil?
    }
  end


  def self.parse_street_name(street, country_code)
    return nil unless country_code.to_sym == :US
    StreetAddress::US.parse(street)
  end
end
