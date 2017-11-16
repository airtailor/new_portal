SendSonar.configure do |config|
  config.token = Credentials.sonar_token# || 'YOUR_PRODUCTION_TOKEN'
  if Rails.env.production?
    config.env = :live
  else
    config.env = :sandbox
  end
end
