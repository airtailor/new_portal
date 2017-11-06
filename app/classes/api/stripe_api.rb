class StripeAPI
  def create_stripe_customer(meta_data)
    Stripe::Customer.create(metadata: meta_data)
  end

  def set_default_source_for_customer(strpe_id, source_token)
    customer = Stripe::Customer.retrieve(stripe_id)
    customer.source = source_token

    if customer.save
      customer
    else
      false
    end
  end

  def create_charge(amount, stripe_id)
    charge = Stripe::Charge.create(
      amount: amount,
      customer: stripe_id
    )

    if charge["status"] == "succeeded"
      charge
    else
      false
    end
  end
end
