module ShipmentConstants

  # Shipment Types
  MESSENGER = 'messenger_shipment'
  MAIL      = 'mail_shipment'

  # Shipment Actions
  SHIP_RETAILER_TO_TAILOR    = 'SHIP_RETAILER_TO_TAILOR'
  SHIP_TAILOR_TO_RETAILER    = 'SHIP_TAILOR_TO_RETAILER'
  SHIP_CUSTOMER_TO_TAILOR    = 'SHIP_CUSTOMER_TO_TAILOR'
  SHIP_TAILOR_TO_CUSTOMER    = 'SHIP_TAILOR_TO_CUSTOMER'
  SHIP_RETAILER_TO_CUSTOMER  = 'SHIP_RETAILER_TO_CUSTOMER'

  def parse_src_dest(src_dest)
    case src_dest
    when SHIP_RETAILER_TO_TAILOR
      [Retailer, Tailor]
    when SHIP_TAILOR_TO_RETAILER
      [Tailor, Retailer]
    when SHIP_CUSTOMER_TO_TAILOR
      [Customer, Tailor]
    when SHIP_TAILOR_TO_CUSTOMER
      [Tailor, Customer]
    else
      nil
    end
  end

end
