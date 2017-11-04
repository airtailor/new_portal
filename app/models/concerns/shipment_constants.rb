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

  def parse_src_dest(action, type)
    case action
    when SHIP_RETAILER_TO_TAILOR
      [:retailer, :tailor]
    when SHIP_TAILOR_TO_RETAILER
      type == MAIL ? [:tailor, :retailer] : nil
    when SHIP_CUSTOMER_TO_TAILOR
      type == MAIL ? [:customer, :tailor] : nil
    when SHIP_TAILOR_TO_CUSTOMER
      type == MAIL ? [:tailor, :customer] : nil
    when SHIP_RETAILER_TO_CUSTOMER
      type == MAIL ? [:retailer, :customer] : nil
    else
      nil
    end
  end

end
