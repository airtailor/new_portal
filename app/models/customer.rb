class Customer < ApplicationRecord
  validates :email, :phone, presence: true, uniqueness: true
  validates :shopify_id, uniqueness: true, allow_blank: true
  validates :first_name, :last_name, presence: true

  # belongs_to :default_tailor, polymorphic: true

  has_many :orders, inverse_of: :customer
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
    if !address = self.addresses.first
      address = self.addresses.build.parse_and_save(address_params)
    end

    return address
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

    customer = Customer.find_or_create_by(phone: phone) do |customer|
      customer.email = shopify_customer["email"]
      customer.shopify_id = shopify_customer["id"]

      cust_details = shopify_customer["default_address"]
      customer.first_name = cust_details["first_name"]
      customer.last_name = cust_details["last_name"]
      customer.company = cust_details["company"]
      customer.street1 = cust_details["address1"]
      customer.street2 = cust_details["address2"]
      customer.city = cust_details["city"]
      customer.state = cust_details["province"]
      customer.zip = cust_details["zip"]
      customer.country = cust_details["country_name"]
    end

    # update with most recent shopify attributes if customer already existed
    customer.email = shopify_customer["email"]
    customer.shopify_id = shopify_customer["id"]

    cust_details = shopify_customer["default_address"]
    customer.first_name = cust_details["first_name"]
    customer.last_name = cust_details["last_name"]
    customer.company = cust_details["company"]
    customer.street1 = cust_details["address1"]
    customer.street2 = cust_details["address2"]
    customer.city = cust_details["city"]
    customer.state = cust_details["province"]
    customer.zip = cust_details["zip"]
    customer.country = cust_details["country_name"]
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
