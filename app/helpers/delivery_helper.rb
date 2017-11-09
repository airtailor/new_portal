module DeliveryHelper

  def create_label(shipment)
    return Api::Shippo.build_label(shipment)
  end

  def request_messenger
    return Api::Postmates.build_messenger_delivery(self.source, self.destination)
  end

  def delivery_can_be_executed?(source, dest)
    orders = self.orders
    counts = {
      retailer: orders.map(&:requester_id).uniq,
      tailor: orders.map(&:provider_id).uniq,
      customer: orders.map(&:customer_id).uniq
    }

    return [source, dest].all?{ |klass| counts[klass] == 1 }
  end

  def get_parcel
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
    when "TailorOrder"
       return {
        length: 7,
        width: 5,
        height: 3,
        distance_unit: :in,
        weight: self.orders.sum(&:weight),
        mass_unit: :g
      }
    end
  end

end
