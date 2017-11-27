class BackfillOldAddresses < ActiveRecord::Migration[5.0]

  def up
    require 'street_address'
    build_address_table(Store)
    build_address_table(Customer)
  end

  def down
    Store.update_all(address_id: nil)
    CustomerAddress.destroy_all
    Address.destroy_all
  end

  def build_address_table(klass_string, id_array = nil)
    build_through_join = true if klass_string == Customer
    klass = id_array.blank? ? klass_string : klass_string.where(id: id_array)

    klass.all.each do |geo_obj|
      next if skip_obj(geo_obj)
      address = Address.new
      address = set_address_fields(address, geo_obj)
      if address_is_invalid?(address)
        next
      else
        binding.pry unless address.save
        if build_through_join
          geo_obj.addresses << address
        else
          geo_obj.address = address
        end

        binding.pry unless geo_obj.save
      end
    end
  end

  def set_street(address, geo_obj)
    addy_string = "#{geo_obj.street1} #{geo_obj.city}, #{geo_obj.state} #{geo_obj.zip}"
    return nil unless address.country_code.to_sym == :US
    return StreetAddress::US.parse(addy_string) rescue nil
  end

  def set_country(geo_obj)
    all_countries, all_codes = Address::COUNTRIES, Address::COUNTRY_CODES
    country = all_countries.get(geo_obj.country)
    country ||= geo_obj.country if all_codes.get(geo_obj.country)
    country ||= "UNITED STATES"
    return country
  end

  def set_country_code(geo_obj)
    Address::COUNTRY_CODES.get(geo_obj.country) || "US"
  end

  def set_state_province(geo_obj)
    return geo_obj.state if Address::STATES.get(geo_obj.state)
    Address::STATE_CODES.get(geo_obj.state)
  end

  def update_from_parsed_street(address, parsed_street)
    address.assign_attributes({
        number: parsed_street.number,
        street: [ parsed_street.prefix, parsed_street.street,
                  parsed_street.street_type, parsed_street.suffix
                ].compact.join(" "),
        city:  parsed_street.city,
        zip_code: parsed_street.postal_code,
        unit: parsed_street.unit
    })

    return address
  end

  def update_without_valid_parsed_street(address, geo_obj)
    address.number = geo_obj.street1.scan(/^\d+/)[0] || nil
    if address.number
      just_street = geo_obj.street1.split(/^\d+\W+/).reject{|elem| elem == ""}
      address.street = just_street.join(" ")
    else
      address.street = geo_obj.street1
    end
    address.city = geo_obj.city
    address.zip_code = geo_obj.zip
    return address
  end

  def set_address_fields(address, geo_obj)
    address.country = set_country(geo_obj)
    address.country_code = set_country_code(geo_obj)
    address.state_province = set_state_province(geo_obj)

    address.floor, address.unit = nil, nil
    address.street_two = geo_obj.street2

    parsed_street = set_street(address, geo_obj)
    if !parsed_street
      street_split_arr = geo_obj.street1.split(", ")
      geo_obj.street1 = street_split_arr.select{ |str| str.match(/^[0-9]+/) }.first
      parsed_street = set_street(address, geo_obj)
    end

    if parsed_street
      address = update_from_parsed_street(address, parsed_street)
    else
      address = update_without_valid_parsed_street(address, geo_obj)
    end

    return address
  end

  def address_is_invalid?(address)
    [ address.city, address.zip_code, address.state_province, address.number,
      address.street
    ].any?{ |field| field.blank?}
  end

  def skip_obj(obj)
    [:street1, :city, :state, :zip, :country].any? { |a|
      obj.send(a).nil?
    }
  end

end
