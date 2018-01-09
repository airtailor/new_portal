module DeliveryHelper

  def create_label(shipment)
    return Api::Shippo.build_label(shipment)
  end

  def request_messenger
    return Api::Postmates.build_messenger_delivery(self.source, self.destination)
  end

  def delivery_can_be_executed?(source, dest, orders)
    return true if orders.length == 1
    counts = {
      retailer: orders.map(&:requester_id).uniq.count,
      tailor: orders.map(&:provider_id).uniq.count,
      customer: orders.map(&:customer_id).uniq.count
    }

    return [source, dest].all?{ |klass|
      counts[klass] == 1
    }
  end

  def get_parcel
    #: NOTE FLAG FOR REFACTOR
    # CHECKING ELSE BECAUSE
    # We need to figure out why Order.send_shipping_label_email_to_customer
    # shipment can't have relationship to orders using .built even though it
    # seems to work correctly in ShipmentsController#create
    all_order_types = self.orders.map(&:type).uniq
    return nil if all_order_types.length > 1

    case all_order_types.first
    when "WelcomeKit"
      return {
        length: 6,
        width: 4,
        height: 1,
        distance_unit: :in,
        weight: 28,
        mass_unit: :g
      }
    else
       return {
        length: 7,
        width: 5,
        height: 3,
        distance_unit: :in,
        weight: self.weight,
        mass_unit: :g
      }
    end
  end

  def self.update_messenger_status(data)
    delivery_id = data["delivery_id"]
    delivery_status = data["data"]["status"]
    shipment = Shipment.find_by(postmates_delivery_id: delivery_id)

    if delivery_status != shipment.status
      shipment.update_attributes(status: delivery_status)
    end
  end
end
