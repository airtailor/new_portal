require 'rails_helper'

RSpec.describe Api::ShipmentsController, type: :controller do 
  context "when the shipment is for a welcome kit" do 
    before :each do 
      user = FactoryGirl.create(:user, store: FactoryGirl.create(:retailer))
      @user = sign_in_retailer user
      @order = FactoryGirl.create(:welcome_kit, retailer: @user.store)
      params = {}
      params[:shipment] = {}
      params[:shipment][:order_id] = @order.id
      params[:shipment][:type] = "OutgoingShipment"
      post :create, params
    end

    describe "POST #create" do 
      it "redirects to the order page" do 
        expect(response).to redirect_to store_order_path(@user.store, @order)
      end

      it "creates a new shipment outgoing" do 
        expect(Shipment.count).to eq(1) 
      end

      it "is the outgoing shipment for its order" do 
        expect(@order.outgoing_shipment).to eq(OutgoingShipment.last) 
      end
    end
  end
end
