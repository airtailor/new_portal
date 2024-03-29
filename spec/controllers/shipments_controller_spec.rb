# require 'rails_helper'

# RSpec.describe Api::ShipmentsController, type: :controller do
#   context "when the shipment is for a welcome kit" do
#     before :each do
#       user = FactoryBot.create(:user, store: FactoryBot.create(:retailer))
#       @user = sign_in_retailer user
#       @order = FactoryBot.create(:welcome_kit, retailer: @user.store)
#       params = {}
#       params[:shipment] = {}
#       params[:shipment][:order_id] = @order.id
#       params[:shipment][:type] = "OutgoingShipment"
#       post :create, params
#     end

#     describe "POST #create" do
#       it "responds with a 200 ok" do
#         expect(response).to be_success
#       end

#       it "creates a new shipment outgoing" do
#         expect(OutgoingShipment.count).to eq(1)
#       end

#       it "is the outgoing shipment for its order" do
#         expect(@order.outgoing_shipment).to eq(OutgoingShipment.last)
#       end
#     end
#   end

#   context "when it is an outgoing shipment for a tailor order" do
#     before :each do
#       user = FactoryBot.create(:user, store: FactoryBot.create(:retailer))
#       @user = sign_in_retailer user
#       @order = FactoryBot.create(:shopify_tailor_order, retailer: @user.store)
#       params = {}
#       params[:shipment] = {}
#       params[:shipment][:order_id] = @order.id
#       params[:shipment][:type] = "OutgoingShipment"
#       post :create, params
#     end

#     describe "POST #create" do
#       it "responds with a 200 ok" do
#         expect(response).to be_success
#       end

#       it "creates a new shipment outgoing" do
#         expect(OutgoingShipment.count).to eq(1)
#       end

#       it "is the outgoing shipment for its order" do
#         expect(@order.outgoing_shipment).to eq(OutgoingShipment.last)
#       end
#     end
#   end
# end
