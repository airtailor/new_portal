require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :controller do
  before :each do
    @tailor = FactoryBot.create(:tailor)
    @tailor.set_address(street: "626 W 139th St", city: "New York", state_province: "NY", zip_code: "10031")

    @airtailor_co = FactoryBot.create(:company, name: "Air Tailor")
    @airtailor_store = FactoryBot.create(:retailer, name: "Air Tailor", company: @airtailor_co, default_tailor: @tailor)

    @retailer_co = FactoryBot.create(:company, name: "J.Crew")
    @retailer_store = FactoryBot.create(:retailer, name: "J.Crew - E-commerce", company: @retailer_co, default_tailor: @tailor)

    @admin_user = FactoryBot.create(:user, store: @airtailor_store)
    @admin_user.add_role "admin"

    @retailer_user = FactoryBot.create(:user, store: @retailer_store)
    @retailer_user.add_role "retailer"
    @retailer_user.add_api_key

    @auth_headers = {"X-Api-Key": "#{@retailer_user.api_key}", "Content-Type": "application/json"}

    # need to specify customer in this order so that we
    # use a unique and valid phone number, and
    # use the same first name so they both come up in the search
    #@customer_one = FactoryBot.create(:customer, phone: 9045668701, first_name: "Jones")
    #@customer_two = FactoryBot.create(:customer, phone: 6167804457, first_name: "Jones")

    #@order_one = FactoryBot.create(
    #  :retailer_tailor_order,
    #  retailer: @retailer_store,
     # customer: @customer_one
    #)

    #@order_two = FactoryBot.create(
    #  :retailer_tailor_order,
    #  retailer: @airtailor_store,
    #  customer: @customer_two
    #)

    #@order_three = FactoryBot.create(
    #  :retailer_tailor_order,
    #  retailer: @airtailor_store,
    #  customer: @customer_two
    #)
   
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
    it "returns a 200 ok" do
      request.headers.merge!(@auth_headers)
      data = {order: FactoryBot.build(:ecommerce_order_request, retailer: @retailer_store, items: @items)}
      post :create, params: data
      byebug
      expect(response).to be_success
    end
  end

  # describe "GET #search" do
  #   it "returns a 200 ok" do
  #     get :search, {query: "#{@order_one.customer.first_name}"}.merge(@auth_headers)
  #     expect(response).to be_success
  #   end
  #
  #   context "when the user is an admin" do
  #     it "allows them to search for other store's orders" do
  #       get :search, {query: "#{@order_one.customer.first_name}"}.merge(@auth_headers)
  #       data = JSON.parse(response.body)
  #       expect(data.count).to eq(Order.count)
  #     end
  #   end
  #
  #   context "when the user is not an admin" do
  #     it "allows them to search for only their store's orders" do
  #       @auth_headers = @retailer_user.create_new_auth_token
  #       get :search, {query: "#{@order_one.customer.first_name}"}.merge(@auth_headers)
  #       data = JSON.parse(response.body)
  #       expect(data.count).to eq(1)
  #     end
  #   end
  # end
  #
  # describe "GET #archived" do
  #   before :each do
  #     @order_one.set_fulfilled
  #     @order_two.set_fulfilled
  #     @order_three.set_fulfilled
  #   end
  #
  #   it "returns a 200 ok" do
  #     get :archived, {}.merge(@auth_headers)
  #     expect(response).to be_success
  #   end
  #
  #   it "returns fulfilled orders" do
  #     get :archived, {}.merge(@auth_headers)
  #     data = JSON.parse(response.body)
  #     fulfilled = data.first["fulfilled"]
  #     expect(fulfilled).to be(true)
  #   end
  #
  #   it "is ordered by recent fulfilled date" do
  #     get :archived, {}.merge(@auth_headers)
  #     data = JSON.parse(response.body)
  #     first_date = data.first["fulfilled_date"]
  #     second_date = data.second["fulfilled_date"]
  #     expect(first_date > second_date).to be(true)
  #   end
  #
  #   context "when the user is not an admin" do
  #     it "returns only their store's fulfilled orders" do
  #       @auth_headers = @retailer_user.create_new_auth_token
  #       get :archived, {}.merge(@auth_headers)
  #       data = JSON.parse(response.body)
  #       expect(data.count).to eq(1)
  #     end
  #   end
  #
  #   context "when the user is an admin" do
  #     it "returns all fulfilled orders" do
  #       fulfill_count = Order.where(fulfilled: true).count
  #       get :archived, {}.merge(@auth_headers)
  #       data = JSON.parse(response.body)
  #       expect(data.count).to eq(fulfill_count)
  #     end
  #   end
  # end
end
