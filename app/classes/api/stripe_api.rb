class StripeAPI
  def create_stripe_customer(meta_data)
    Stripe::Customer.create(metadata: meta_data)
  end

  def set_default_source_for_customer(stripe_id, source_token)
    customer = Stripe::Customer.retrieve(stripe_id)
    customer.source = source_token

    begin
      customer.save
      return customer
    rescue => e
      return {error: {status: e.http_status, message: e.message}}
    end
  end

  def create_charge(amount, stripe_id)
    begin
      stripe_charge = Stripe::Charge.create(
        amount: amount,
        customer: stripe_id,
        currency: "usd"
      )

    rescue => e
      return {error: {status: e.http_status, message: e.message}}
    end

    if stripe_charge["status"] == "succeeded"
      stripe_charge
    else
      e.message ||= false
    end
  end
end
