require 'rails_helper'

RSpec.describe Store, type: :model do
  context "when the store is valid" do 
    before :each do 
      @store = FactoryGirl.create(:store)
    end

    it "defaults country to United States if no country provided" do 
      valid_store = FactoryGirl.create(:store, country: nil)
      expect(valid_store.country).to eq("United States")
    end

    it "has access to the PaymentHelper module methods" do 
      expect(@store.respond_to?(:add_stripe_id))
      expect(@store.respond_to?(:add_default_payment))
      expect(@store.respond_to?(:charge))
    end

    describe "#add_stripe_id" do 
      before :each { @stripe_customer = @store.add_stripe_id }

      it "returns a valid Stripe customer" do 
        expect(@stripe_customer).to_not eq(nil)
      end

      it "adds a stripe id to the store" do 
        expect(@store.stripe_id).to eq(@stripe_customer["id"])
      end
    end

    describe "#add_default_payment" do 
      before :each do 
        token = "tok_visa_debit"
        @store.add_stripe_id
        @stripe_customer = @store.add_default_payment(token)
      end

      it "returns a valid Stripe customer" do 
        expect(@stripe_customer).to_not eq(nil)
      end

      it "adds a default payment method for the Stripe customer" do 
        expect(@stripe_customer.default_source).to_not eq(nil)
      end
    end

    describe "#charge" do 
      it "returns a valid Stripe charge" do 
        token = "tok_visa_debit"
        @store.add_stripe_id
        @stripe_customer = @store.add_default_payment(token)
        @charge =  @store.charge(100)
        expect(@charge).to_not eq(nil)
        expect(@charge["status"]).to eq("succeeded")
      end

      context "when the payment is declined" do 
        it "returns nil" do 
          token = "tok_chargeDeclined"
          @store.add_stripe_id
          @stripe_customer = @store.add_default_payment(token)
          @charge =  @store.charge(100)
          expect(@charge).to eq(nil)
        end
      end
    end
  end

  it "is invalid without a name" do
    invalid_store = FactoryGirl.build(:store, name: nil)
    expect(invalid_store).to_not be_valid
  end
end
