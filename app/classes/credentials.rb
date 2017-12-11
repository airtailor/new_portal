class Credentials

  def self.secret_key_base
    Rails.application.secrets.secret_key_base
  end

  def self.stripe_secret_key
    Rails.application.secrets.stripe_secret_key
  end


  def self.shopify_api_key
    Rails.application.secrets.shopify_api_key
  end

  def self.shopify_api_password
    Rails.application.secrets.shopify_api_password
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

  def self.sonar_token
    Rails.application.secrets.sonar_token
  end

  def self.at_gmail_pw
    Rails.application.secrets.at_gmail_pw
  end

  def self.at_gmail_user
    Rails.application.secrets.at_gmail_user
  end

  def self.delighted_token
    Rails.application.secrets.delighted_token
  end

  def self.postmates_token
    Rails.application.secrets.postmates_token
  end

  def self.postmates_id
    Rails.application.secrets.postmates_id
  end


end
