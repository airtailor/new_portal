require 'rails_helper'

RSpec.describe Api::ShopifyController, type: :controller do
  describe "POST #receive" do
    before :each do
      co = FactoryBot.create(:company, name: "Air Tailor")
      FactoryBot.create(:retailer, name: "Air Tailor", company: co)
    end

    it "creates a new order" do
      order_count = TailorOrder.count
      request_body = FactoryBot.build(:shopify_tailor_order_request)
      post :receive, request_body.to_json
      expect(TailorOrder.count > order_count).to be(true)
    end

    it "creates items" do
      item_count = Item.count
      request_body = FactoryBot.build(:shopify_tailor_order_request)
      post :receive, request_body.to_json
      expect(Item.count > item_count).to be(true)
    end

    it "ties items to their alterations" do
       request_body = FactoryBot.build(:shopify_tailor_order_request)
       post :receive, request_body.to_json
       expect(Item.first.alterations.first).to eq(Alteration.first)
    end

    it "makes Air Tailor the Retailer" do
      request_body = FactoryBot.build(:shopify_tailor_order_request)
      post :receive, request_body.to_json
      expect(TailorOrder.first.retailer.name).to eq("Air Tailor")
      expect(TailorOrder.first.retailer.company.name).to eq("Air Tailor")
    end

    context "when the customer already exists via shopify id" do
      it "does not create a new customer" do
        existing_customer = FactoryBot.create(:shopify_customer)
        cust_count = Customer.all.count
        request_body = FactoryBot.build(:shopify_tailor_order_request,
          customer: FactoryBot.build(:api_shopify_customer,
            id: existing_customer[:shopify_id]
          )
        )
        2.times { post :receive, request_body.to_json }
        expect(Customer.all.count == cust_count).to be(true)
      end
    end

    context "when the customer does not yet exist" do
      it "creates a new customer" do
        cust_count = Customer.all.count
        request_body = FactoryBot.build(:shopify_tailor_order_request)
        post :receive, request_body.to_json
        expect(Customer.all.count > cust_count).to be(true)
      end
    end

    context "when the order is placed more than once" do
      it "creates only one tailor order" do
        request_one = FactoryBot.build(:shopify_tailor_order_request).to_json
        request_two = request_one
        post :receive, request_one
        post :receive, request_two
        expect(TailorOrder.count).to eq(1)
      end

      it "creates only one welcome kit" do
        request_one = FactoryBot.build(:shopify_welcome_kit).to_json
        request_two = request_one
        post :receive, request_one
        post :receive, request_two
        
        expect(WelcomeKit.count).to eq(1)
      end

      it "does not create duplicate items on the same order" do
        request_one = FactoryBot.build(:shopify_tailor_order_request).to_json
        request_two = request_one
        post :receive, request_one
        item_count = Item.count
        post :receive, request_two
        expect(Item.count == item_count).to be(true)
      end
    end

    context "when the order is a welcome kit" do
      it "creates a welcome kit", :focus => true do
        request_body = FactoryBot.build(:shopify_welcome_kit).to_json
        post :receive, request_body
        expect(WelcomeKit.count).to eq(1)
      end

      it "does not create a tailor order" do 
        request_body = FactoryBot.build(:shopify_welcome_kit).to_json
        post :receive, request_body
        expect(TailorOrder.count).to eq(0)
      end
    end
  end
end
