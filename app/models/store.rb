class Store < ApplicationRecord

  belongs_to :company
  belongs_to :primary_contact, class_name: "User", foreign_key: "primary_contact_id", optional: true
  belongs_to :address

  belongs_to :default_tailor
  has_many   :retailers

  has_many :items, through: :orders
  has_many :alterations, through: :orders

  has_many :orders
  has_many :users

  validates :name, :phone, :company, presence: true
  # validates :default_tailor, presence: true, if: :is_retailer?

  def set_address(params)
    address = Address.new
    if address.parse_and_save(params, self.type.downcase)
      self.address = address
    end
  end

  def tailor_orders
    self.orders.by_type("TailorOrder")
  end

  def welcome_kits
    self.orders.by_type("WelcomeKit")
  end

  def open_orders
    if self.type == "Tailor"
      self.orders.tailor_open_orders
    elsif self.type == "Retailer"
      self.orders.open_orders
    end
  end

  def retailer_orders
    self.orders.retailer_view
  end

  def late_orders_count
    open_orders.late(true).count
  end

  def active_orders_count
    if self.type == "Retailer"
      self.open_orders.count
    elsif self.type == "Tailor"
      self.orders.active.count
    end
  end

  def arrived_orders_count
    self.orders.fulfilled(false).arrived(true).count
  end

  def transit_to_tailor_count
    self.orders.where(arrived: false).count
  end

  private

  def is_retailer?
    self.type == "Retailer"
  end
end
