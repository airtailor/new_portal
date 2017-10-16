class ServiceWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something generic
    puts "SERVICE WORKER DID THIS ONE"
  end
end
