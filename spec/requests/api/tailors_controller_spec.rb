require 'rails_helper'

RSpec.describe Api::TailorsController, type: :controller do
  before :each do
  @airtailor_co = FactoryGirl.create(:company, name: "Air Tailor")
  @airtailor_store = FactoryGirl.create(:retailer, name: "Air Tailor", company: @airtailor_co)

  customers = [
    FactoryGirl.create(:customer, phone: 9045668701, first_name: "Jones"),
    FactoryGirl.create(:customer, phone: 6167804457, first_name: "Bob")
  ]

  binding.pry
  10.times do
    FactoryGirl.create(
      :shopify_tailor_order,
      retailer: @airtailor_store,
      customer: customers.sample
    )
  end

  @admin_user = FactoryGirl.create(:user, store: @airtailor_store)
  @admin_user.add_role "admin"

  @auth_headers = @admin_user.create_new_auth_token

end

  describe "GET #index" do
    it "returns a 200 ok" do
      get :index, {}.merge(@auth_headers)
      expect(response).to be_success
    end
  end
end
