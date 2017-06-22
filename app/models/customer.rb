class Customer < ApplicationRecord
  validates :email, :phone, presence: true, uniqueness: true
  validates :shopify_id, uniqueness: true
  validates :first_name, :last_name, :street1, :street2, :city, :zip,
   :country, presence: true


  def self.find_or_create(shopify_customer)
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
    Shippo.api_token = ENV["SHIPPO_KEY"]
    byebug
    Shippo::Address.create( 
      :object_purpose => "PURCHASE",
      :name => self.name,
      :street1 => self.street1,
      :street2 => self.street2,
      :city => self.city,
      :country => self.country,
      :zip => self.zip,
      :phone => self.phone,
      :email => self.email,
      :validate => true
    )
    byebug
  end

end

