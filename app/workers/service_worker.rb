class ServiceWorker
  include Sidekiq::Worker

  def perform(*args)
    # Do something generic
    puts "SERVICE WORKER LOGGED THIS MESSAGE."
  end
end
