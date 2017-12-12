require 'rails_helper'

RSpec.describe Api::PaymentsController, type: :controller do
  before :each do 
    @airtailor_co = FactoryBot.create(:company, name: "Air Tailor")
    @airtailor_store = FactoryBot.create(:retailer, name: "Air Tailor", company: @airtailor_co)

    @retailer_co = FactoryBot.create(:company, name: "J.Crew")
    @retailer_store = FactoryBot.create(:retailer, name: "J.Crew - 5th Ave", company: @retailer_co)
    @retailer_store.add_stripe_id 

    @admin_user = FactoryBot.create(:user, store: @airtailor_store)
    @admin_user.add_role "admin"

    @retailer_user = FactoryBot.create(:user, store: @retailer_store)
    @retailer_user.add_role "retailer"

    @auth_headers = @retailer_user.create_new_auth_token
  end
  
  describe "POST #update_payment_method" do 
    context "when the token is valid" do 
      before :each do 
        @payment = {
          payable_type: @retailer_store.type, 
          payable_id: @retailer_store.id, 
          token: "tok_visa_debit" 
        }
      end

      it "returns a 200 ok" do 
        post :update_payment_method, {payment: @payment}.merge(@auth_headers)
        binding.pry
        expect(response).to be_success
      end
    end
  end
end
