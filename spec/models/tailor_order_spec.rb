require 'rails_helper'

RSpec.describe TailorOrder, type: :model do

  it "is invalid without a retailer" do
    invalid_shopify_tailor_order = FactoryGirl.build(:shopify_tailor_order, retailer: nil)
    expect(invalid_shopify_tailor_order).to be_invalid
  end

  it "is invalid without a customer_id" do 
    invalid_shopify_tailor_order = FactoryGirl.build(:shopify_tailor_order, customer_id: nil)
    expect(invalid_shopify_tailor_order).to be_invalid
  end

  it "is invalid without a tailor" do
    valid_retailer= FactoryGirl.create(:retailer)
    invalid_shopify_tailor_order = FactoryGirl.build(:shopify_tailor_order, tailor: nil, retailer: valid_retailer)
    expect(invalid_shopify_tailor_order).to be_invalid
  end

  describe "#arrived" do 
    before :each do 
        @valid_shopify_tailor_order = FactoryGirl.create(:shopify_tailor_order)
        @valid_shopify_tailor_order.set_arrived
    end

    it "set arrived to true" do 
        expect(@valid_shopify_tailor_order.arrived).to eq(true)
    end

    it "adds the arrival date when the order arrives" do 
        expect(@valid_shopify_tailor_order.arrival_date.today?).to eq(true)
    end

    it "adds the due date when the order arrives" do 
      expect(@valid_shopify_tailor_order.due_date).to eq(5.days.from_now.at_midnight)
    end
  end


  describe "#fulfilled" do 
    before :each do 
        @valid_shopify_tailor_order = FactoryGirl.create(:shopify_tailor_order)
        @valid_shopify_tailor_order.set_fulfilled
    end

    it "adds the fulfilled date" do 
        expect(@valid_shopify_tailor_order.fulfilled_date.today?).to eq(true)
    end

    it "set fulfilled to true" do 
      expect(@valid_shopify_tailor_order.fulfilled).to eq(true)
    end
  end

  context "when the order is from shopify" do
    before :each do
      company = FactoryGirl.create(:company, name: "Air Tailor")
      FactoryGirl.create(:retailer, name: "Air Tailor", company: company)
    end

    it "has shopify as it's source by default" do
      valid_shopify_tailor_order = FactoryGirl.create(:shopify_tailor_order)
      expect(valid_shopify_tailor_order.source).to eq("Shopify")
    end
  end
end
