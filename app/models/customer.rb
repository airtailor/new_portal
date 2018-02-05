class Customer < ApplicationRecord
  validates :email, :phone, uniqueness: true, presence: true
  validates :shopify_id, uniqueness: true, allow_blank: true
  validates :first_name, :last_name, presence: true

  has_many :orders, inverse_of: :customer
  has_many :shipments, through: :orders, inverse_of: :customer

  has_many :measurements, inverse_of: :customer
  has_many :customer_addresses
  has_many :addresses, through: :customer_addresses

  def last_measurement
    self.measurements.last
  end
  
  after_create :create_blank_measurements

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

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def address
    self.addresses.first || self.shippo_address
  end

  def shippo_address
    return address.shippo_address if address = addresses.first

    return {
      :name => self.name,
      :street1 => self.street1,
      :street2 => self.street2,
      :city => self.city,
      :country => self.country,
      :state => self.state,
      :zip => self.zip,
      :phone => self.try(:phone),
      :email => self.try(:email)
    }
  end
end
