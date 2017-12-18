require 'rails_helper'

RSpec.describe Order, type: :model do
  before :each do
    @co = FactoryBot.create(:company, name: "Air Tailor")
    @airtailor= FactoryBot.create(:retailer, name: "Air Tailor", company: @co)
  end

  it "is invalid without a retailer" do
    invalid_order = FactoryBot.build(:order, retailer: nil)
    expect(invalid_order).to be_invalid
  end

  it "is invalid without a customer" do
    invalid_order = FactoryBot.build(:order, customer: nil)
    expect(invalid_order).to be_invalid
  end

  describe "has relationships with retailer and customers" do
    before :each do
      FactoryBot.create(:order, retailer: @airtailor)
    end

    it "has a relationship with retailer" do
      expect(Order.last.retailer.name).to eq("Air Tailor")
    end

    it "has a relationship with customers" do
      expect(Order.last.customer).to eq(Customer.last)
    end
  end

  describe "#init" do
    it "adds the source Shopify by default" do
      order = FactoryBot.build(:order, retailer: @airtailor, source: nil)
      order.set_order_defaults
      expect(order.source).to eq("Shopify")
    end

    it "adds the retailer Air Tailor by default" do
      order = FactoryBot.build(:order, retailer: nil, source: "Shopify")
      order.set_order_defaults
      expect(order.retailer.name).to eq("Air Tailor")
    end
  end


  describe "#find_or_create" do
    it "creates a new order if it does not exist" do
      order = FactoryBot.build(:shopify_tailor_order)
      created_order = Order.find_or_create(
        {
          "name" => "##{order.source_order_id}",
          "subtotal_price" => 1234,
          "total_price" => 5432
        },
        order.customer,
        order.source
      )
      expect(created_order).to eq(Order.first)
    end

    it "finds the order if the source order id already exists in an order" do
      order = FactoryBot.create(:shopify_tailor_order)
      second_call = Order.find_or_create(
        {"name" => "##{order.source_order_id}"},
        order.customer,
        order.source
      )
      expect(second_call).to eq(order)
    end
  end

end
