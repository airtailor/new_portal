require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  before :each do
    @tailor = FactoryBot.create(:tailor)
    @tailor.set_address(street: "626 W 139th St", city: "New York", state_province: "NY", zip_code: "10031")

    @retailer_co = FactoryBot.create(:company, name: "J.Crew")
    @retailer_store = FactoryBot.create(:retailer, name: "J.Crew - E-commerce", company: @retailer_co, default_tailor: @tailor)

    @retailer_user = FactoryBot.create(:user, store: @retailer_store)
    @retailer_user.add_role "retailer"
    @retailer_user.add_api_key

    @auth_headers = {"X-Api-Key": "#{@retailer_user.api_key}", "Content-Type": "application/json"}

    @items = [    
      {
        "item_type_id": FactoryBot.create(:item_type, id: 7, name: "Pants").id,
        "alterations": [
          { "alteration_id":  FactoryBot.create(:alteration, id: 208).id },
          { "alteration_id":  FactoryBot.create(:alteration, id: 219).id }
        ]
      },
      {
        "item_type_id": FactoryBot.create(:item_type, id: 6, name: "Shirt").id,
        "alterations": [
          { "alteration_id":  FactoryBot.create(:alteration, id: 36).id }
        ]
      }
    ]

  end

  describe "POST #create" do
    context "when the request is successful" do 
      before(:each) do 
        request.headers.merge!(@auth_headers)
        data = {order: FactoryBot.build(:ecommerce_order_request, retailer: @retailer_store, items: @items)}
        post :create, params: data
      end

      it "returns a 200 ok" do
        expect(response).to be_success
      end

      it "has a correct total" do
        expect(JSON.parse(response.body)["total"]).to eq(63.5)
      end

      it "has a correct weight" do
        expect(JSON.parse(response.body)["weight"]).to eq(1130)
      end
    end

    context "when it has an invalid api key" do 
      it "responds with an error" do 
        @auth_headers = {"X-Api-Key": "", "Content-Type": "application/json"}
        request.headers.merge!(@auth_headers)
        data = {order: FactoryBot.build(:ecommerce_order_request, retailer: @retailer_store, items: @items)}
        post :create, params: data
        expect(JSON.parse(response.body)["errors"].first).to eq("Access Denied")
      end
    end

    context "when it has an invalid item_type_id" do 
      it "responds with an error" do 
        @items.first["item_type_id"] = 9000
        request.headers.merge!(@auth_headers)
        data = {order: FactoryBot.build(:ecommerce_order_request, retailer: @retailer_store, items: @items)}
        post :create, params: data
        expect(JSON.parse(response.body)["errors"].first).to eq("Couldn't find ItemType with 'id'=9000")
      end
    end

    context "when it has an invalid alteration_id" do 
      it "responds with an error" do 
        @items.first[:alterations].first[:alteration_id] = 9000
        request.headers.merge!(@auth_headers)
        data = {order: FactoryBot.build(:ecommerce_order_request, retailer: @retailer_store, items: @items)}
        post :create, params: data
        expect(JSON.parse(response.body)["errors"].first).to eq("Couldn't find Alteration with 'id'=9000")
      end
    end
  end

  context "when it has invalid customer data" do 
    it "responds with an error" do 
      request.headers.merge!(@auth_headers)
      data = {
        order: FactoryBot.build(
          :ecommerce_order_request, 
          retailer: @retailer_store, 
          items: @items,
          customer: FactoryBot.build(:ecommerce_customer, first_name: "")
        )
      }
      post :create, params: data
      expect(JSON.parse(response.body)["errors"].first).to eq("First name can't be blank")
    end
  end

  context "when it has no data" do 
    it "responds with an error" do 
      request.headers.merge!(@auth_headers)
      data = {}
      post :create, params: data
      expect(JSON.parse(response.body)["errors"].first).to eq("param is missing or the value is empty: order")
    end
  end

  context "when it has no items" do 
    it "responds with an error" do 
      request.headers.merge!(@auth_headers)
      data = {
        order: FactoryBot.build(
          :ecommerce_order_request, 
          retailer: @retailer_store, 
          items: [],
          customer: FactoryBot.build(:ecommerce_customer)
        )
      }
      post :create, params: data
      expect(JSON.parse(response.body)["errors"].first).to eq("param is missing or the value is empty: items")
    end
  end

  context "when alterations are empty" do 
    it "responds with an error" do 
      request.headers.merge!(@auth_headers)
      @items.first[:alterations] = []

      data = {
        order: FactoryBot.build(
          :ecommerce_order_request, 
          retailer: @retailer_store, 
          items: @items,
          customer: FactoryBot.build(:ecommerce_customer)
        )
      }
      post :create, params: data
      expect(JSON.parse(response.body)["errors"].first).to eq("param is missing or the value is empty: alterations")
    end
  end

  context "when alterations are nil" do 
    it "responds with an error" do 
      request.headers.merge!(@auth_headers)
      @items.first[:alterations] = nil

      data = {
        order: FactoryBot.build(
          :ecommerce_order_request, 
          retailer: @retailer_store, 
          items: @items,
          customer: FactoryBot.build(:ecommerce_customer)
        )
      }
      post :create, params: data
      expect(JSON.parse(response.body)["errors"].first).to eq("param is missing or the value is empty: alterations")
    end
  end

  context "when it has no customer data" do 
    it "responds with an error" do 
      request.headers.merge!(@auth_headers)
      data = {
        order: FactoryBot.build(
          :ecommerce_order_request, 
          retailer: @retailer_store, 
          items: @items,
          customer: {}
        )
      }
      post :create, params: data
      expect(JSON.parse(response.body)["errors"].first).to eq("param is missing or the value is empty: customer")
    end
  end

  context "when it has invalid customer address" do 
    it "responds with an error" do 
      request.headers.merge!(@auth_headers)

      data = {
        order: FactoryBot.build(
          :ecommerce_order_request, 
          retailer: @retailer_store, 
          items: @items,
          customer: FactoryBot.build(:ecommerce_customer, street: "")
        )
      }
      post :create, params: data
      expect(JSON.parse(response.body)["errors"].first).to eq("Invalid Address")
    end
  end
end

