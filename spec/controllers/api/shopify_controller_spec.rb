require 'rails_helper'

RSpec.describe Api::ShopifyController, type: :controller do
  before :each do
    co = FactoryGirl.create(:company, name: "Air Tailor")
    FactoryGirl.create(:retailer, name: "Air Tailor", company: co)
  end

  describe "POST #receive" do
    # it "creates a new order" do
    #   request_body = FactoryGirl.build(:shopify_tailor_order_request)
    #   post :receive, request_body.to_json
    #   byebug
    # end

    it "creates items" do
    end

    it "ties items to their alterations" do
    end

    it "makes Air Tailor the Retailer" do
    end

    context "when the customer already exists via shopify id" do
      # it "does not create a new customer" do
      #   existing_customer = FactoryGirl.create(:shopify_customer)
      #   request_body = FactoryGirl.build(:shopify_tailor_order_request,
      #     customer: FactoryGirl.build(:api_shopify_customer,
      #       id: existing_customer[:shopify_id]
      #     )
      #   )
      #   post :receive, request_body.to_json
      #   # expect block -
      # end
    end

    context "when the customer does not yet exist" do
      it "creates a new customer" do
        request_body = FactoryGirl.build(:shopify_tailor_order_request)
        post :receive, request_body.to_json
        # expect block

      end
    end

    context "when the order is placed more than once" do
      it "creates only one order"
    end
  end
end
