require 'rails_helper'

RSpec.describe Charge, type: :model do
  describe "#initiate_charge" do
    before :each do
      @payable = FactoryGirl.create(:retailer)

      @chargable = FactoryGirl.create(
        :retailer_tailor_order,
        retailer: @payable,
        source: "React-Portal"
      )

      @payable.add_stripe_id

      @stripe_charge= Charge.initiate_charge(
        @chargable.total,
        @payable.stripe_id
      )

      @charge_count = Charge.count
    end

    context "when the Stripe customer has an active card on Stripe" do
      before :each do
        token = "tok_visa_debit"
        @payable.add_default_payment(token)
      end

      it "is invalid without an amount" do
        charge = Charge.new(
          payable: @payable,
          chargable: @chargable,
          stripe_id: @stripe_charge[:id]
        )

        expect(charge.valid?).to eq(false)
      end

      #it "is invalid without a chargable" do
      #  charge = Charge.new(
      #    payable: @payable,
      #    amount: @chargable.total,
      #    stripe_id: @stripe_charge[:id]
      #  )
      #  expect(charge.valid?).to eq(false)
      #end

      it "is invalid without a payable" do
        charge = Charge.new(
          chargable: @chargable,
          amount: @chargable.total,
          stripe_id: @stripe_charge[:id]
        )
        expect(charge.valid?).to eq(false)
      end
    end

    context "when the Stripe customer has no active card" do
      it "does not create a Charge" do
        expect(@stripe_charge[:status]).to eq(402)
        expect(@charge_count).to eq(Charge.count)
      end
    end
  end

  it "has access to the PaymentHelper module methods" do
    expect(@store.respond_to?(:charge))
  end



  # describe "#charge" do
  #   context "when the payment is accepted" do
  #     before :each do
  #       @charge_count = Charge.count
  #       @token = "tok_visa_debit"
  #       @store.add_stripe_id
  #       @stripe_customer = @store.add_default_payment(@token)
  #       @charge =  @store.charge(100)
  #     end
  #
  #     it "returns a valid Charge" do
  #       expect(@charge).to_not eq(nil)
  #       expect(@charge["status"]).to eq("succeeded")
  #       expect(@charge).to eq(Charge.last)
  #     end
  #
  #     it "creates a Charge" do
  #       expect(@charge_count).to eq(@charge_count + 1)
  #     end
  #   end

    # context "when the payment is declined" do
    #   it "returns nil" do
    #     token = "tok_chargeDeclined"
    #     @store.add_stripe_id
    #     @stripe_customer = @store.add_default_payment(token)
    #     @charge =  @store.charge(100)
    #     expect(@charge).to eq(nil)
    #   end
    # end
#   end
# end
end
