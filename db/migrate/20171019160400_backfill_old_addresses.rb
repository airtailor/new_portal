class BackfillOldAddresses < ActiveRecord::Migration[5.0]

  def up
    require 'street_address'
    build_address_table(Store)
    build_address_table(Customer)
  end

  def down
    Address.where(id: Store.select(:address_id)).destroy_all
    Address.where(id: CustomerAddress.select(:address_id)).destroy_all
    CustomerAddress.destroy_all
  end


  def build_address_table(klass)
    if klass == Customer
      build_through_join = true
    end

    klass.all.each do |geo_obj|
      next if skip_obj(geo_obj)
      address = build_through_join ?  geo_obj.addresses.build : geo_obj.build_address
      address = set_address_fields(address, geo_obj)

      next if [
        address.city,
        address.zip_code,
        address.state_province,
        address.number,
        address.street
      ].any?{ |field| field.blank?}

      address.save
      if build_through_join
        geo_obj.addresses << address
      end
      geo_obj.save
    end
  end

  def set_address_fields(address, geo_obj)
    address.country = Address::COUNTRIES.get(geo_obj.country)
    address.country ||= geo_obj.country if Address::COUNTRY_CODES.get(geo_obj.country)
    address.country ||= "UNITED STATES"

    address.country_code = Address::COUNTRIES.get(address.country)
    address.country_code ||= "US"

    address.state_province = geo_obj.state if Address::STATES.get(geo_obj.state)
    address.state_province ||= Address::STATE_CODES.get(geo_obj.state)

    address.floor, address.unit = nil, nil
    address.street_two = geo_obj.street2

    addy_string = "#{geo_obj.street1} #{geo_obj.city}, #{geo_obj.state} #{geo_obj.zip}"
    parsed_street = parse_street_name(addy_string, address.country_code)

    if parsed_street
      address.number = parsed_street.number
      address.street = [
        parsed_street.prefix, parsed_street.street, parsed_street.street_type
      ].join(" ")

      address.city, address.zip_code = parsed_street.city, parsed_street.postal_code
      address.unit = parsed_street.unit
    else
      address.number = geo_obj.street1.scan(/^\d+/)[0] || nil
      if address.number
        just_street = geo_obj.street1.split(/^\d+\W+/).reject{|elem| elem == ""}
        address.street = just_street.join(" ")
      end
      address.city = geo_obj.city
      address.zip_code = geo_obj.zip
    end

    return address
  end

  def skip_obj(obj)
    [:street1, :city, :state, :zip, :country].any? { |a|
      obj.send(a).nil?
    }
  end


  def parse_street_name(street, country_code)
    return nil unless country_code.to_sym == :US
    StreetAddress::US.parse(street) rescue nil
  end

end
