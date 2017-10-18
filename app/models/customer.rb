class Customer < ApplicationRecord
  validates :email, :phone, presence: true, uniqueness: true
  validates :shopify_id, uniqueness: true, allow_blank: true
  validates :first_name, :last_name, presence: true

  has_many :addresses, inverse_of: :customer, through: :customer_addresses
  has_many :measurements

  def last_measurement
    self.measurements.last
  end

  before_validation :add_country
  after_create :create_blank_measurements

  def add_country
    self.country = "United States"
  end

  def create_blank_measurements
    customer = self
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
      customer: customer
    )
  end

  def self.find_or_create_shopify(shopify_customer)
    Customer.find_or_create_by(shopify_id: shopify_customer["id"]) do |customer|
      customer.email = shopify_customer["email"]

      cust_details = shopify_customer["default_address"]
      customer.first_name = cust_details["first_name"]
      customer.last_name = cust_details["last_name"]
      customer.phone = cust_details["phone"]
      customer.company = cust_details["company"]
      customer.street1 = cust_details["address1"]
      customer.street2 = cust_details["address2"]
      customer.city = cust_details["city"]
      customer.state = cust_details["state"]
      customer.zip = cust_details["zip"]
      customer.country = cust_details["country_name"]
    end
  end

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def shippo_address
    address.for_shippo(self)
  end

end
