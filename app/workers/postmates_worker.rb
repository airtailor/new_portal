class PostmatesWorker < ServiceWorker
  # include PostmatesHelper
  # include Sidekiq::Worker
  #
  # def perform(shipment, from, to, parcel)
  #   # request a messenger on postmates
  #   # make sure we're good here
  #   from = shipment.source.for_postmates
  #   to   = shipment.destination.for_postmates
  #   parcel = shipment.get_parcel
  #
  #   params = {
  #     quote_id: nil
  #     manifest: # some value here.
  #     manifest_reference: # probably shipment #?
  #     pickup_name: from[:full_name]
  #     pickup_address: from.full_address
  #     pickup_phone_number: from[:phone_number]
  #     pickup_business_name: from.business_name || nil
  #     pickup_notes: # notes?
  #     dropoff_name: [:full_name]
  #     dropoff_address: from.full_address
  #     dropoff_phone_number: from[:phone_number]
  #     dropoff_business_name: from.business_name || nil
  #     dropoff_notes: # ??
  #     requires_id: # ??
  #   }
  #
  #   # create_delivery is in PostmatesHelper
  #   # should it be? probably?
  #   response = create_delivery(params)
  #
  #   shipment.update(response)
  # end
end
