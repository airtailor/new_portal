require 'rails_helper'

RSpec.describe Order, type: :model do
  it "is invalid without a retailer" do
    invalid_order = FactoryGirl.build(:order, retailer: nil)
    expect(invalid_order).to be_invalid
  end

  it "is invalid without a customer" do
    invalid_order = FactoryGirl.build(:order, customer: nil)
    expect(invalid_order).to be_invalid
  end

  describe "has relationships with retailer and customers" do
    before :each do
      co = FactoryGirl.create(:company, name: "Air Tailor")
      airtailor = FactoryGirl.create(:retailer, name: "Air Tailor", company: co)
      FactoryGirl.create(:order, retailer: airtailor)
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
      co = FactoryGirl.create(:company, name: "Air Tailor")
      airtailor = FactoryGirl.create(:retailer, name: "Air Tailor", company: co)
      order = FactoryGirl.create(:order, retailer: airtailor)
      expect(order.source).to eq("Shopify")
    end

    it "adds the retailer Air Tailor by default" do
      order = FactoryGirl.create(:order)
      expect(order.retailer.name).to eq("Air Tailor")
    end
  end

  describe "#set_arrived" do
    before :each do
      valid_order = FactoryGirl.create(:order)
      valid_order.set_arrived
    end

    it "set arrived to true" do
      expect(Order.last.arrived).to eq(true)
    end

    it "adds the arrival date when the order arrives" do
      expect(Order.last.arrival_date.today?).to eq(true)
    end

    it "adds the due date when the order arrives" do
      expect(Order.last.due_date).to eq(5.days.from_now.at_midnight)
    end
  end

  describe "#fulfilled" do
    before :each do
      valid_order = FactoryGirl.create(:order)
      valid_order.set_fulfilled
    end

    it "adds the fulfilled date" do
      expect(Order.last.fulfilled_date.today?).to eq(true)
    end

    it "set fulfilled to true" do
      expect(Order.last.fulfilled).to eq(true)
    end
  end

  describe "#find_or_create" do
    it "creates a new order if it does not exist" do
      order = FactoryGirl.build(:order)
      co = FactoryGirl.create(:company, name: "Air Tailor")
      airtailor = FactoryGirl.create(:retailer, name: "Air Tailor", company: co)
      created_order = Order.find_or_create(
        {
          "id" => order.source_order_id,
          "subtotal_price" => 1234,
          "total_price" => 5432
        },
        order.customer,
        order.source
      )
      expect(created_order).to eq(Order.first)
    end

    it "finds the order if the source order id already exists in an order" do
      order = FactoryGirl.create(:order)
      second_call = Order.find_or_create(
        {"id" => order.source_order_id},
        order.customer,
        order.source
      )
      expect(second_call).to eq(order)
    end
  end

end
