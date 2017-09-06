class Shipment < ApplicationRecord
  validates :type, :shipping_label, :tracking_number, :weight, presence: true
  belongs_to :order

  after_initialize :add_order_weight, :configure_shippo
  after_create :send_text_to_customer

  private

  def send_text_to_customer
    if ((self.order.retailer.name != "Air Tailor") && (self.type == "OutgoingShipment"))
      customer = self.order.customer
      customer_message = "Good news, #{customer.first_name.capitalize} -- your " + 
        "Airtailor Order (id: #{self.order.id}) is finished and is on its way to you! " + 
        "Here's your USPS tracking number: #{self.tracking_number}"
      SendSonar.message_customer(text: customer_message, to: customer.phone)
    end
  end

  def add_order_weight
    self.weight = self.order.weight
  end

  def configure_shippo
    Shippo.api_token = ENV["SHIPPO_KEY"]
    Shippo.api_version = '2017-03-29'
    to_address = get_ship_to_address
    from_address = get_ship_from_address
    parcel = get_parcel
    puts "\n\n\n to_address #{to_address}"
    puts "\n\n\n from_address #{from_address}"
    puts "\n\n\n parcel #{parcel}"
    shippo_shipment = create_shippo_shipment(to_address, from_address, parcel)
    shippo_transaction = create_shippo_transaction(shippo_shipment)
    add_shipping_label(shippo_transaction)
    add_tracking_number(shippo_transaction)
  end

  def get_ship_to_address
    if self.type == "OutgoingShipment"
      # outgoing shipments always go to customer! :* )
      if self.order.ship_to_store
        get_retailer_address
      else
        get_customer_address
      end
    elsif self.type == "IncomingShipment"
      get_tailor_address if self.order.type == "TailorOrder"
      get_retailer_address if self.order.type == "WelcomeKit"
    end
  end

  def get_ship_from_address
    if self.type == "OutgoingShipment"
      puts "GET SHIP FROM ADDRESS - OUTGOING SHIPMENT order type - #{self.order.type}"
      return get_tailor_address if self.order.type == "TailorOrder"
      return get_retailer_address if self.order.type == "WelcomeKit"
    elsif self.type == "IncomingShipment"
      return get_customer_address
    end
  end

  def get_customer_address
    self.order.customer.shippo_address
  end

  def get_tailor_address
    self.order.tailor.shippo_address
  end

  def get_retailer_address
    self.order.retailer.shippo_address
  end

  def get_parcel
    if self.order.type == "WelcomeKit"
      {
        length: 6,
        width: 4,
        height: 1,
        distance_unit: :in,
        weight: 28,
        mass_unit: :g
      }
    elsif self.order.type == "TailorOrder"
       {
        length: 7,
        width: 5,
        height: 3,
        distance_unit: :in,
        weight: self.order.weight,
        mass_unit: :g
      }
    end
  end

  def create_shippo_shipment(to_address, from_address, parcel)
    shipment = Shippo::Shipment.create(
      object_purpose: "PURCHASE",
      address_from: from_address,
      address_to: to_address,
      parcels: parcel,
      async: false
    )
  end

  def get_shipping_rate(rates)
    rates.find {|r| r.attributes.include? "BESTVALUE"}
  end

  def create_shippo_transaction(shippo_shipment)
    transaction = Shippo::Transaction.create(
      #rate: shippo_shipment[:rates].first[:object_id],
      #rate: shippo_shipment[:rates].find {|r| r.attributes.include? "BESTVALUE"},
      rate: get_shipping_rate(shippo_shipment[:rates]),
      label_file_type: "PNG",
      async: false
    )
  end

  def add_shipping_label(shippo_transaction)
    self.shipping_label = shippo_transaction[:label_url]
  end

  def add_tracking_number(shippo_transaction)
    self.tracking_number = shippo_transaction[:tracking_number]
  end
end
