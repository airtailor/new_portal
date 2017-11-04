SendSonar.configure do |config|
  if Rails.env.production?
    config.env = :live
    config.token = Credentials.sonar_production_token# || 'YOUR_PRODUCTION_TOKEN'

  elsif Rails.env.development?
    config.env = :sandbox
    config.token = Credentials.sonar_sandbox_token# || 'YOUR_SANDBOX_TOKEN'
  elsif Rails.env.test?
    config.env = :sandbox
    config.token = Credentials.sonar_sandbox_token# || 'YOUR_SANDBOX_TOKEN'
  end
end
