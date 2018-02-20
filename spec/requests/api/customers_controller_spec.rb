require 'rails_helper'

RSpec.describe Api::CustomersController, type: :controller do
  before :each do 
    @tailor_store = FactoryBot.create(:tailor)

    @airtailor_co = FactoryBot.create(:company, name: "Air Tailor")
    @airtailor_store = FactoryBot.create(:retailer, name: "Air Tailor", company: @airtailor_co, default_tailor: @tailor_store)

    @retailer_co = FactoryBot.create(:company, name: "J.Crew")
    @retailer_store = FactoryBot.create(:retailer, name: "J.Crew - 5th Ave", company: @retailer_co, default_tailor: @tailor_store)

    @admin_user = FactoryBot.create(:user, store: @airtailor_store)
    @admin_user.add_role "admin"

    @retailer_user = FactoryBot.create(:user, store: @retailer_store)
    @retailer_user.add_role "retailer"

    @auth_headers = @admin_user.create_new_auth_token
    
    @retailer_auth_headers = @retailer_user.create_new_auth_token

    # need to specify customer in this order so that we 
    # use a unique and valid phone number, and 
    # use the same first name so they both come up in the search
    @customer_one = FactoryBot.create(:customer, phone: 9045668701, first_name: "Jones")
    @customer_two = FactoryBot.create(:customer, phone: 6167804457, first_name: "Jones")

    @order_one = FactoryBot.create(
      :retailer_tailor_order,
      retailer: @retailer_store,
      customer: @customer_one
    )

    @order_two = FactoryBot.create(
      :retailer_tailor_order,
      retailer: @airtailor_store,
      customer: @customer_two
    )

    @order_three = FactoryBot.create(
      :retailer_tailor_order,
      retailer: @airtailor_store,
      customer: @customer_two
    )
  end

  describe "GET #customer_orders" do
    it "returns a 200 ok" do
      byebug
      get "/api/customers/#{@customer_one.id}/customer_orders"
      #get "/customers/#{@customer_one.id}/customer_orders", {}.merge(@auth_headers)
      expect(response).to be_success
    end

    context "when the user is a retailer" do 
      it "allows them to see only orders from their store" do 
      get :customer_orders, {customer_id: @customer_two.id}.merge(@retailer_auth_headers)
        data = JSON.parse(response.body)
        expect(data.count).to eq(1)
      end
    end

    context "when the user is not a retailer" do 
      it "allows them to see any order from that customer" do 
        get :customer_orders, {customer_id: @customer_two.id}.merge(@auth_headers)
        data = JSON.parse(response.body)
        expect(data.count).to eq(Order.count)
      end
    end
  end
end
