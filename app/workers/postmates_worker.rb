class PostmatesWorker < ServiceWorker
  include PostmatesHelper
  include Sidekiq::Worker

  # perform is defined on service_worker.
  # if we don't want to make a generic object for external integrations,
  # we can just move it all over here.

  def perform(shipment)
    # request a messenger on postmates
    # make sure we're good here

    from = shipment.source.for_postmates
    to   = shipment.destination.for_postmates
    parcel = shipment.get_parcel

    # create_delivery is in PostmatesHelper
    # should it be? probably?

  end
end
