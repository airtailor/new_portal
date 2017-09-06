SendSonar.configure do |config|
  if Rails.env.production?
    config.env = :live
    config.token = ENV['SONAR_PRODUCTION_TOKEN']# || 'YOUR_PRODUCTION_TOKEN'

  elsif Rails.env.development?
    config.env = :sandbox
    config.token = ENV['SONAR_SANDBOX_TOKEN']# || 'YOUR_SANDBOX_TOKEN'
    #config.env = :live
    #config.token = ENV['SONAR_PRODUCTION_TOKEN']# || 'YOUR_PRODUCTION_TOKEN'
  end
end
