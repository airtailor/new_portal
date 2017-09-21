require 'rails_helper'

RSpec.describe Api::OrdersController, type: :controller do
  before :each do 
      @airtailor_co = FactoryGirl.create(:company, name: "Air Tailor")
      @airtailor_store = FactoryGirl.create(:retailer, name: "Air Tailor", company: @airtailor_co)

      @retailer_co = FactoryGirl.create(:company, name: "J.Crew")
      @retailer_store = FactoryGirl.create(:retailer, name: "J.Crew - 5th Ave", company: @retailer_co)

      @admin_user = FactoryGirl.create(:user, store: @airtailor_store)
      @admin_user.add_role "admin"

      @retailer_user = FactoryGirl.create(:user, store: @airtailor_store)
      @retailer_user.add_role "retailer"

      @auth_headers = @admin_user.create_new_auth_token
     

      # need to specify customer in this order so that we 
      # use a unique and valid phone number, and 
      # use the same first name so they both come up in the search
      @customer_one = FactoryGirl.create(:customer, phone: 9045668701, first_name: "Jones")
      @customer_two = FactoryGirl.create(:customer, phone: 6167804457, first_name: "Jones")
      @order_one = FactoryGirl.create(
        :retailer_tailor_order,
        retailer: @retailer_store,
        customer: @customer_one
      )

      @order_two = FactoryGirl.create(
        :retailer_tailor_order,
        retailer: @airtailor_store,
        customer: @customer_two
      )

      @order_three = FactoryGirl.create(
        :retailer_tailor_order,
        retailer: @airtailor_store,
        customer: @customer_two
      )
  end

  describe "GET #search" do
    it "returns a 200 ok" do
      get :search, {query: "#{@order_one.customer.first_name}"}.merge(@auth_headers)
      expect(response).to be_success
    end

    context "when the user is an admin" do 
      it "allows them to search for other store's orders" do 
        get :search, {query: "#{@order_one.customer.first_name}"}.merge(@auth_headers)
        data = JSON.parse(response.body)
        expect(data.count).to eq(Order.count)
      end
    end
  end

  describe "GET #archived" do
   before :each do 
      @order_two.set_fulfilled
      @order_three.set_fulfilled
    end

    it "returns a 200 ok" do
      get :archived, {}.merge(@auth_headers)
      expect(response).to be_success
    end

    it "returns fulfilled orders" do
      get :archived, {}.merge(@auth_headers)
      data = JSON.parse(response.body)
      fulfilled = data.first["fulfilled"]
      expect(fulfilled).to be(true)
    end

    it "is ordered by recent fulfilled date" do
      get :archived, {}.merge(@auth_headers)
      data = JSON.parse(response.body)
      first_date = data.first["fulfilled_date"]
      second_date = data.second["fulfilled_date"]
      expect(first_date > second_date).to be(true)
    end
  end
end
