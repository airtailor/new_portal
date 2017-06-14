require 'rails_helper'

RSpec.describe WelcomeKit, type: :model do
   it "is invalid without a retailer" do
    invalid_welcome_kit = FactoryGirl.build(:welcome_kit, retailer: nil)
    expect(invalid_welcome_kit).to be_invalid
  end

  it "is invalid without a customer_id" do
    invalid_welcome_kit = FactoryGirl.build(:welcome_kit, customer_id: nil)
    expect(invalid_welcome_kit).to be_invalid
  end

  describe "has relationships with retailer and customers" do
    before :each do
       welcome_kit = FactoryGirl.create(:welcome_kit)
    end

    it "has a relationship with retailer" do
      expect(WelcomeKit.last.retailer).to eq(Retailer.last)
    end

    it "has a relationship with customers" do
      expect(WelcomeKit.last.customer).to eq(Customer.last)
    end
  end

  describe "#fulfilled" do
    before :each do
        @valid_welcome_kit = FactoryGirl.create(:welcome_kit)
        @valid_welcome_kit.set_fulfilled
    end

    it "adds the fulfilled date" do
        expect(@valid_welcome_kit.fulfilled_date.today?).to eq(true)
    end

    it "set fulfilled to true" do
      expect(@valid_welcome_kit.fulfilled).to eq(true)
    end
  end
end
