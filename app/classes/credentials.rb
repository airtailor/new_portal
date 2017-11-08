class Credentials

  def self.secret_key_base
    Rails.application.secrets.secret_key_base
  end

  def self.stripe_api_key
    Rails.application.secrets.stripe_api_key
  end

  def self.shippo_key
    Rails.application.secrets.shippo_key
  end

  def self.shippo_api_version
    Rails.application.secrets.shippo_api_version
  end

  def self.shipping_carrier_account
    Rails.application.secrets.shipping_carrier_account
  end

  def self.sonar_sandbox_token
    Rails.application.secrets.sonar_sandbox_token
  end

  def self.sonar_sandbox_token
    Rails.application.secrets.sonar_sandbox_token
  end

  def self.sonar_production_token
    Rails.application.secrets.sonar_production_token
  end

  def self.at_gmail_pw
    Rails.application.secrets.at_gmail_pw
  end

  def self.at_gmail_user
    Rails.application.secrets.at_gmail_user
  end

  def self.delighted_production_token
    Rails.application.secrets.delighted_production_token
  end

  def self.postmates_sandbox_token
    Rails.application.secrets.postmates_sandbox_token
  end

  def self.postmates_id
    Rails.application.secrets.postmates_id
  end


end
