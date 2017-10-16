class PostmatesWorker < ServiceWorker
  # perform is defined on service_worker.
  # if we don't want to make a generic object for external integrations,
  # we can just move it all over here.

  def perform(*args)
    super args
    puts "POSTMATES WORKER DOES THIS ONE"
  end
end
