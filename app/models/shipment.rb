class Shipment < ApplicationRecord
  validates :type, :shipping_label, :tracking_number, :weight, presence: true
  belongs_to :order

  after_initialize :add_order_weight, :create_shippo_shipment

  private 

  def add_order_weight
    self.weight = self.order.weight if self.order
  end

  def create_shippo_shipment
    return unless self.order
    Shippo.api_token = ENV["SHIPPO_KEY"]
    to_address = get_ship_to_address
    from_address = get_ship_from_address
    parcel = get_parcel
    shippo_hash = create_shippo_hash(to_address, from_address, parcel)
    service_level_token = get_service_level_token
    shippo_transaction = create_shippo_transaction(shippo_hash, service_level_token)
    add_shipping_label(shippo_transaction)
    add_tracking_number(shippo_transaction)
  end

  def get_ship_to_address
    if self.type == "OutgoingShipment"
      # outgoing shipments always go to customer! :* )
      get_customer_address
    elsif self.type == "IncomingShipment"
      get_tailor_address if self.order.type == "TailorOrder"
      get_retailer_address if self.order.type == "WelcomeKit"
    end
  end

  def get_ship_from_address
    if self.type == "OutgoingShipment"
      get_tailor_address if self.order.type == "TailorOrder"
      get_retailer_address if self.order.type == "WelcomeKit"
    elsif self.type == "IncomingShipment"
      get_customer_address
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
      # NEEED MORE INFO
      byebug
    end
  end

  def get_service_level_token
    if (self.weight.to_f < 542 || self.order.type == "WelcomeKit")
      "usps_first"
    else 
      "usps_priority"
    end
  end

  def create_shippo_hash(to_address, from_address, parcel)
    Shippo::api_token = ENV["SHIPPO_KEY"]
    Shippo.api_version = '2017-03-29'
    shipment = Shippo::Shipment.create(
      object_purpose: "PURCHASE",
      address_from: from_address,
      address_to: to_address, 
      parcels: parcel,
      async: false
    )
  end
  
  def create_shippo_transaction(shippo_hash, service_level_token)
    Shippo.api_token = ENV["SHIPPO_KEY"]
    Shippo.api_version = '2017-03-29'
    transaction = Shippo::Transaction.create(
      rate: shippo_hash[:rates].first[:object_id],
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

