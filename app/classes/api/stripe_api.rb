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
      binding.pry
      case e.http_status
      when 402
          return e.message
      else
          return "Oops something went wrong"
      end
    end
  end

  def create_charge(amount, stripe_id)
    charge = Stripe::Charge.create(
      amount: amount,
      customer: stripe_id,
      currency: "usd"
    )

    if charge["status"] == "succeeded"
      charge
    else
      false
    end
  end
end
