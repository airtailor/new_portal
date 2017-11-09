class Order < ApplicationRecord
  has_many :items
  has_many :alterations, through: :items
  has_many :charges, :as => :chargable

  belongs_to :customer, class_name: "Customer", foreign_key: "customer_id"
  belongs_to :retailer, class_name: "Retailer", foreign_key: "requester_id"
  belongs_to :tailor, class_name: "Tailor", foreign_key: "provider_id",
    optional: true

  has_one :outgoing_shipment, class_name: "OutgoingShipment",
    foreign_key: "order_id"
  has_one :incoming_shipment, class_name: "IncomingShipment",
    foreign_key: "order_id"

  validates :retailer, presence: true
  
  after_initialize :init
  after_create :send_order_confirmation_text
  after_update :send_customer_shipping_label_email, if: :provider_id_changed?
  after_update :que_customer_for_delighted, if: :fulfilled_changed?


  def customer_needs_shipping_label
    (self.type != "WelcomeKit") && (self.retailer.name == "Air Tailor") && (!self.incoming_shipment)
  end

  def send_customer_shipping_label_email
    if customer_needs_shipping_label
      shipment = Shipment.create(order: self, type: "IncomingShipment")
      AirtailorMailer.label_email(self.customer, self, self.tailor, shipment).deliver!
    end
  end

  def que_customer_for_delighted
    if (self.fulfilled) && (self.type == "TailorOrder") && (Rails.env == "production")
      Delighted::Person.create(:email => self.customer.email, :delay => 518400, :properties => { :tailor_name => self.tailor.name })
    end
  end

  # This method is overwritten so that the 'type' attribute will
  # be rendered in the json response
  def serializable_hash options=nil
    super.merge "type" => type
  end


  # nuke this
  # def shipments
  #   [
  #     self.outgoing_shipment,
  #     self.incoming_shipment
  #   ]
  # end

  def init
    self.source ||= "Shopify"
    air_tailor_co = Company.where(name: "Air Tailor")
    self.retailer ||= Retailer.find_by(company: air_tailor_co, name: "Air Tailor")
    self.fulfilled ||= false

    if (self.retailer.name == "Steven Alan - Tribeca" ||
        self.retailer.name == "Frame Denim - SoHo" ||
        self.retailer.name == "Rag & Bone - SoHo")

      self.tailor = Tailor.find_by(name: "Tailoring NYC")
    end
  end

  def send_order_confirmation_text
    customer = self.customer
    phone = customer.phone
    email = customer.email
    first_name = customer.first_name
    last_name = customer.last_name

    SendSonar.add_customer(
      phone_number: phone,
      email: email,
      first_name: first_name,
      last_name: last_name,
    )

    if self.retailer.name != "Air Tailor" #&& !(Rails.env.development? || Rails.env.test?)
      customer_message = "Hey #{first_name.capitalize}, your Air " +
        "Tailor order (##{self.id}) has been placed and we are SO excited to " +
        "get to work. We'll text you updates along the way. Thank you!"

        #tags = [self.retailer.name]
        m_url = "https://cdn.shopify.com/s/files/1/0184/1540/files/dancing_kid.gif?9975520961070565248"

        SendSonar.message_customer(
          text: customer_message,
          to: phone,
          #tag_names: tags,
          media_url: m_url
        )
    else
    end
  end

  def arrived=(boolean)
    super(boolean)
    set_arrival_date
    set_due_date
  end

  def fulfilled=(boolean)
    super(boolean)
    set_fulfilled_date
  end

  def self.on_time
    self.where(late: false)
  end

  def self.late
    self.where(late: true)
  end

  def self.find_or_create(order_info, customer, source = "Shopify")
    order = self.find_or_create_by(source_order_id: order_info["name"].gsub("#", "").to_i, source: source) do |order|
      order.customer = customer
      order.total = order_info["total_price"]
      order.subtotal = order_info["subtotal_price"]
      order.discount = order_info["total_discounts"]
      order.requester_notes = order_info["note"]
      order.weight = order_info["total_weight"]
    end
    order
  end

  def set_fulfilled
    self.fulfilled = true
    set_fulfilled_date
  end

  def grab_items_by_type(item_name)
    self.items.select do |item|
      item.item_type.name == item_name
    end
  end

  def set_arrived
    self.update_attributes(arrived: true)
    set_arrival_date
    set_due_date
  end

  def assigned?
    self.tailor != nil
  end

  def self.assigned
    self.where("orders.provider_id IS NOT NULL")
  end

  def self.needs_assigned
    self.where("orders.provider_id IS NULL")
  end

  scope :unfulfilled, -> { where(fulfilled: false)}

  scope :active, -> { where(arrived: true).where(fulfilled: false) }

  scope :archived, -> { where(fulfilled: true) }

  scope :by_due_date, -> { order(:due_date) }

  def items_count
    self.items.count
  end

  def alterations_count
    self.items.reduce(0) do |prev, curr|
      prev += AlterationItem.where(item: curr).count
    end
  end

  def self.search(search)
    id = Order.first.id
    where("id ILIKE ?", "%#{id}%")
    #where("id ILIKE ? OR customer.first_name ILIKE ? OR customer.last_name ILIKE ?", "%#{search}%", "%#{search}%", "%#{search}%")
    #
     #Order.joins(:customers).where("customer.name like '%?%'", search)
  end

  def self.mark_orders_late
    orders = Order.all.where(arrived: true).where(fulfilled: false).where('due_date <= ?', Date.today)

    orders.each do |order|
      order.update_attributes(late: true)
    end
  end

  private

  def set_arrival_date
    self.update_attributes(arrival_date: DateTime.now.in_time_zone.midnight)
  end

  def set_due_date
    self.update_attributes(due_date: 6.days.from_now.in_time_zone.midnight)
  end

  def set_fulfilled_date
    self.update_attributes(fulfilled_date: DateTime.now)
  end
end
