require 'rails_helper'

RSpec.describe Api::ChargesController, type: :controller do
  before :each do 
    @airtailor_co = FactoryGirl.create(:company, name: "Air Tailor")
    @airtailor_store = FactoryGirl.create(:retailer, name: "Air Tailor", company: @airtailor_co)

    @retailer_co = FactoryGirl.create(:company, name: "J.Crew")
    @retailer_store = FactoryGirl.create(:retailer, name: "J.Crew - 5th Ave", company: @retailer_co)
    @retailer_store.add_stripe_id 
    @retailer_store.add_default_payment("tok_visa_debit")

    @admin_user = FactoryGirl.create(:user, store: @airtailor_store)
    @admin_user.add_role "admin"

    @retailer_user = FactoryGirl.create(:user, store: @retailer_store)
    @retailer_user.add_role "retailer"

    @auth_headers = @retailer_user.create_new_auth_token

    # need to specify customer in this order so that we 
    # use a unique and valid phone number, and 
    # use the same first name so they both come up in the search
    @customer_one = FactoryGirl.create(:customer, phone: 9045668701, first_name: "Jones")
    @customer_two = FactoryGirl.create(:customer, phone: 6167804457, first_name: "Jones")

  end
  
  describe "POST #create" do 
    context "when the charge is valid" do 
      before :each do 
        @retailer_store.add_stripe_id 
        @retailer_store.add_default_payment("tok_visa_debit")

        @charge = {
          payable_type: @retailer_store.type, 
          payable_id: @retailer_store.id, 
          amount: 100
        }

      end

      it "returns a 200 ok" do 
        post :create, {charge: @charge}.merge(@auth_headers)
        binding.pry
        expect(response).to be_success
      end
    end
  end
end
