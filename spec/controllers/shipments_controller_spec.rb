require 'rails_helper'

RSpec.describe ShipmentsController, type: :controller do 

  context "when the shipment is for a welcome kit" do 
    before :each do 
      user = FactoryGirl.create(:user, store: FactoryGirl.create(:retailer))
      @user = sign_in_retailer user
      order = FactoryGirl.create(:welcome_kit, retailer: @user.store)
      params = {}
      params[:shipment] = {}
      params[:shipment][:order_id] = order.id
      params[:shipment][:type] = "OutgoingShipment"
      post :create, params
    end

    describe "POST #create" do 
      it "creates redirects to the order page" do 
        expect(response).to redirect_to store_orders_path @user.store, order 
      end
    end
  end
end
