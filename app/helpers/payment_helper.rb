module PaymentHelper
  extend ActiveSupport::Concern

  module ClassMethods
    def initiate_charge(amount, payable_stripe_id)
      charge = StripeAPI.new.create_charge(amount, payable_stripe_id)
    end
  end

  def add_stripe_id
    meta_data = {customer_type: self.class.name, customer_name: self.name}
    stripe_customer = StripeAPI.new.create_stripe_customer(meta_data)

    if stripe_customer
      self.update_attributes(stripe_id: stripe_customer[:id])
      stripe_customer
    else
      false
    end
  end

  def add_default_payment(source_token)
    StripeAPI.new.set_default_source_for_customer(self.stripe_id, source_token)
  end
end
