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
      #{}"/api/orders/search#{order.id}",
    end
  end
end
