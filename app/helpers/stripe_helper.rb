module StripeHelper
  def config
    Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
  end

  def create_stripe_customer(customer)
    config

    meta_data = {customer_type: customer.class.name}
    stripe_customer = Stripe::Customer.create(meta_data: meta_data)

    if stripe_customer
      customer.update_attributes(stripe_id: stripe_customer[:id])
    else
      false
    end
  end

  def set_default_source_for_customer(customer, source_token)
    config

    customer = Stripe::Customer.retrieve(customer.stripe_id)
    customer.source = source_token

    if customer.save
      customer
    else
      false
    end
  end

  def create_charge(amount, customer)
    config

    charge = Stripe::Charge.create(
      amount: amount,
      customer: customer.stripe_id
    )

    if charge["status"] == "succeeded"
      charge
    else
      false
    end
  end
end
