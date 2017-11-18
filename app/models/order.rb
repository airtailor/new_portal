class Order < ApplicationRecord
  include OrderConstants

  has_many :items
  has_many :alterations, through: :items
  has_many :item_types, through: :items

  has_many :shipment_orders
  has_many :shipments, through: :shipment_orders

  belongs_to :customer, inverse_of: :orders, class_name: "Customer", foreign_key: "customer_id"
  belongs_to :retailer, inverse_of: :orders, class_name: "Retailer", foreign_key: "requester_id"
  belongs_to :tailor,   inverse_of: :orders, class_name: "Tailor",   foreign_key: "provider_id",
    optional: true

  validates :retailer, presence: true

  scope :by_type, -> type { where(type: type) }
  scope :fulfilled, -> bool { where(fulfilled: bool)}
  scope :assigned, -> bool { where(provider_id: nil) }
  scope :unassigned, -> bool { where.not(provider_id: nil) }

  scope :arrived, -> bool { where(arrived: bool)}
  scope :late, -> bool { where(late: bool) }

  scope :past_due, -> bool { where('due_date <= ?', Date.today) }
  scope :open_orders, -> { order(:due_date).fulfilled(false) }
  scope :active, -> { arrived(true).fulfilled(false) }

  def set_order_defaults
    self.source ||= "Shopify"
    self.retailer ||= Retailer.where( company: Company.where(name: "Air Tailor")).first
    self.tailor ||= self.retailer.default_tailor

    self.arrived ||= false
    self.fulfilled ||= false
    self.late ||= false
    self.dismissed ||= false
end

def parse_order_lifecycle_stage
    date = DateTime.now.in_time_zone.midnight

    self.arrival_date   = date if self.arrived && !self.arrival_date
    self.due_date       = date + 6.days if !self.due_date
    self.fulfilled_date = date if self.fulfilled && !self.fulfilled_date
    self.late           = true if self.due_date && self.due_date < date
  end

  def send_shipping_label_email_to_customer
    if is_customer_direct_tailor_order
      customer, tailor = self.customer, self.tailor
      params = {
        source: customer, destination: tailor,
        delivery_type: Shipment::MAIL
      }

      unless shipment = self.shipments.where(params).first
        shipment = self.shipments.build(params)
        shipment.deliver
        shipment.save
      end

      if Rails.env == 'production'
        AirtailorMailer.label_email(customer, self, tailor, shipment).deliver!
      end
    end
  end


  def queue_customer_for_delighted
    if Rails.env == 'production' && needs_delighted
      Delighted::Person.create(
        :email => self.customer.email, :delay => 518400,
        :properties => { :tailor_name => self.tailor.name }
      )
    end
  end

  # This method is overwritten so that the 'type' attribute will
  # be rendered in the json response
  def serializable_hash options=nil
    super.merge "type" => type
  end

  def text_order_customers
    if (self.retailer.name != "Air Tailor") && (self.fulfilled)
      customer = self.customer
      customer_message = "Good news, #{customer.first_name.capitalize} -- your " +
        "Airtailor Order (id: #{self.id}) is finished and is on its way to you! " +
        "Here's your USPS tracking number: #{self.tracking_number}"
      SendSonar.message_customer(text: customer_message, to: customer.phone)
    end
  end

  def send_order_confirmation_text
    customer = self.customer

    phone = customer.phone
    first_name = customer.first_name

    SendSonar.add_customer(
      phone_number: customer.phone,
      email: customer.email,
      first_name: first_name,
      last_name: customer.last_name,
    )

    if self.retailer.name != "Air Tailor"
      customer_message = "Hey #{first_name.capitalize}, your Air " +
        "Tailor order (##{self.id}) has been placed and we are SO excited to " +
        "get to work. We'll text you updates along the way. Thank you!"

        m_url = "https://cdn.shopify.com/s/files/1/0184/1540/files/dancing_kid.gif?9975520961070565248"
        SendSonar.message_customer(
          text: customer_message,
          to: phone,
          media_url: m_url
        )
    end
  end


  def self.find_or_create(order_info, customer, source = "Shopify")
    order = self.find_or_create_by(source_order_id: order_info["name"].gsub("#", "").to_i, source: source) do |order|
      order.customer = customer
      order.total = order_info["total_price"]
      order.subtotal = order_info["subtotal_price"]
      order.discount = order_info["total_discounts"]
      order.requester_notes = order_info["note"]
      order.weight = order_info["total_weight"]

      order.set_order_defaults
      order.parse_order_lifecycle_stage
    end

    order
  end

  def alterations_count
    AlterationItem.where(item: self.items).count
  end

  def self.search(search)
    id = Order.first.id
    where("id ILIKE ?", "%#{id}%")
    #where("id ILIKE ? OR customer.first_name ILIKE ? OR customer.last_name ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
    #
     #Order.joins(:customers).where("customer.name like '%?%'", search)
  end

  private

  def is_customer_direct_tailor_order
    self.type != WELCOME_KIT && self.retailer.name == "Air Tailor"
  end

  def needs_delighted
    self.fulfilled && self.type == "TailorOrder"
  end

end
