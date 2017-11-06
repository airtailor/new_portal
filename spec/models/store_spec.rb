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
      it "returns a valid Stripe customer" do 
        stripe_customer = @store.add_stripe_id
        expect(stripe_customer).to_not eq(nil)
      end
    end
  end

  it "is invalid without a name" do
    invalid_store = FactoryGirl.build(:store, name: nil)
    expect(invalid_store).to_not be_valid
  end
end
