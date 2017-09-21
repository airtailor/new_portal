require 'rails_helper'

RSpec.describe Api::OrdersController, type: :controller do
  describe "GET #search" do
    before :each do
      co = FactoryGirl.create(:company, name: "Air Tailor")
      @store = FactoryGirl.create(:retailer, name: "Air Tailor", company: co)

      @user = FactoryGirl.create(:user, store: @store)
      @auth_headers = @user.create_new_auth_token
    end

    it "returns a 200 ok" do
      order = FactoryGirl.create(
        :retailer_tailor_order,
        retailer: @store 
      )

      get :search, {query: "#{order.customer.first_name}"}.merge(@auth_headers)
      expect(response).to be_success
    end
  end

  describe "GET #archived" do
    before :each do
      airtailor_co = FactoryGirl.create(:company, name: "Air Tailor")
      store = FactoryGirl.create(:retailer, name: "Air Tailor", company: airtailor_co)

      co = FactoryGirl.create(:company, name: "J.Crew")
      @store = FactoryGirl.create(:retailer, name: "J.Crew - 5th Ave", company: co)

      @user = FactoryGirl.create(:user, store: @store)
      @auth_headers = @user.create_new_auth_token

      order = FactoryGirl.create(
        :retailer_tailor_order,
        retailer: @store 
      )
      order.set_fulfilled
    end

    it "returns a 200 ok" do
      get :archived, {}.merge(@auth_headers)
      expect(response).to be_success
    end

    it "returns archived orders" do
      get :archived, {}.merge(@auth_headers)
      fulfilled = JSON.parse(response.body).first["fulfilled"]
      expect(fulfilled).to be(true)
    end
  end
end
