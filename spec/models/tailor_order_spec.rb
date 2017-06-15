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

  it "is valid without a tailor" do
    valid_retailer= FactoryGirl.create(:retailer)
    invalid_shopify_tailor_order = FactoryGirl.build(:shopify_tailor_order, tailor: nil, retailer: valid_retailer)
    expect(invalid_shopify_tailor_order).to be_valid
  end

  it "is valid with a tailor" do
    valid_retailer= FactoryGirl.create(:retailer)
    valid_tailor = FactoryGirl.create(:tailor)
    invalid_shopify_tailor_order = FactoryGirl.build(:shopify_tailor_order, tailor: valid_tailor, retailer: valid_retailer)
    expect(invalid_shopify_tailor_order).to be_valid
  end

  describe "has relationships with tailor, retailer, items, alterations, customers" do
    before :each do
       valid_tailor_order = FactoryGirl.create(:shopify_tailor_order)
       5.times do
        FactoryGirl.create(:item, order: valid_tailor_order)
      end
    end

    it "has a relationship with tailor" do
      expect(TailorOrder.last.tailor).to eq(Tailor.last)
    end

    it "has a relationship with retailer" do
      expect(TailorOrder.last.retailer).to eq(Retailer.last)
    end

    it "has a relationship with items" do
      expect(TailorOrder.last.items).to eq(Item.all)
    end

    it "has a relationship with alterations" do
      Item.all.each do |item|
        alt = FactoryGirl.create(:alteration)
        FactoryGirl.create(:alteration_item, item: item, alteration: alt)
      end
      expect(TailorOrder.last.alterations).to eq(Alteration.all)
    end

    it "has a relationship with customers" do
      expect(TailorOrder.last.customer).to eq(Customer.first)
    end
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
    it "has shopify as it's source by default" do
      valid_shopify_tailor_order = FactoryGirl.create(:shopify_tailor_order)
      expect(valid_shopify_tailor_order.source).to eq("Shopify")
    end
  end
end
