class Customer < ApplicationRecord
  validates :email, :phone, uniqueness: true
  validates :shopify_id, uniqueness: true, allow_blank: true

  has_many :orders, inverse_of: :customer
  has_many :shipments, through: :orders, inverse_of: :customer

  has_many :measurements, inverse_of: :customer
  has_many :customer_addresses
  has_many :addresses, through: :customer_addresses

  def last_measurement
    self.measurements.last
  end

  before_validation :add_country
  after_create :create_blank_measurements

  def add_country
    self.country ||= "United States"
  end

  def set_address(address_params)
    # NOTE: customers are locked into a single address, but can have more later
    # without DB updates.
      address = Address.new
    if address.parse_and_save(address_params, "customer")
      self.customer_addresses.destroy_all
      self.addresses << address
    end
    # begin
    #   address = Address.new
    #   address.parse_and_save(address_params, "customer")
    #   self.customer_addresses.destroy_all
    #   self.addresses << address
    # rescue => e
    #   raise ActiveModel::Errors.new(e)
    # end
  end

  def create_blank_measurements
    Measurement.create(
      sleeve_length: 0,
      chest_bust: 0,
      upper_torso: 0,
      waist: 0,
      pant_length: 0,
      hips: 0,
      thigh: 0,
      knee: 0,
      calf: 0,
      ankle: 0,
      back_width: 0,
      bicep: 0,
      inseam: 0,
      forearm: 0,
      customer: self
    )
  end

  def self.find_or_create_shopify(shopify_customer)
    phone = shopify_customer["default_address"]["phone"]
      .gsub("(", "")
      .gsub(")", "")
      .gsub("-", "")
      .gsub(" ", "")
      .gsub("–", "")
      .gsub("+", "")

    made_new_customer = false
    customer = Customer.find_or_create_by(phone: phone) do |customer|
      made_new_customer = true

      cust_details = shopify_customer["default_address"]

      customer.email = shopify_customer["email"]
      customer.shopify_id = shopify_customer["id"]
      customer.first_name = cust_details['first_name']
      customer.last_name = cust_details['last_name']

      address_params = {
        'street' => cust_details['address1'],
        'unit' => cust_details['address2'],
        'city' => cust_details['city'],
        'state_province' => cust_details['province'],
        'zip_code' => cust_details['zip'],
        'country' => cust_details['country_name'],
        'country_code' => cust_details['country_code']
      }

      customer.set_address(address_params)
    end
    # update with most recent shopify attributes if customer already existed
    if !made_new_customer
      cust_details = shopify_customer["default_address"]
      customer.email = shopify_customer["email"]
      customer.shopify_id = shopify_customer["id"]
      customer.first_name = cust_details["first_name"]
      customer.last_name = cust_details["last_name"]
      customer.company = cust_details["company"]

      address_params = {
        'street' => cust_details['address1'],
        'unit' => cust_details['address2'],
        'city' => cust_details['city'],
        'state_province' => cust_details['province'],
        'zip_code' => cust_details['zip'],
        'country' => cust_details['country_name'],
        'country_code' => cust_details['country_code']
      }

      customer.set_address(address_params)
    end

    customer
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def shippo_address
    return address.for_shippo if address = addresses.first
    return nil
  end

end
