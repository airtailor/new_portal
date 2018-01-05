require 'rails_helper'
require_relative '../../factories/postmates_webhook'

RSpec.describe Api::PostmatesController, type: :controller do
  describe "POST #receive" do
    before :each do
      at = FactoryBot.create(:company, name: "Air Tailor")
      FactoryBot.create(:retailer, name: "Air Tailor", company: at)

      sa = FactoryBot.create(:company, name: "Steven Alan")
      @retailer = FactoryBot.create(:retailer, name: "Steven Alan Tribeca", company: sa)

      t = FactoryBot.create(:company, name: "Tailoring NYC")
      @tailor = FactoryBot.create(:tailor, name: "Tailoring NYC - Soho", company: t)

      @order = FactoryBot.create(:retailer_tailor_order, retailer: @retailer, tailor: @tailor)
    end

    it "responds with a 200 ok" do 
      FactoryBot.create(
        :postmates_delivery, 
        status: "pending",
        orders: [@order],
        source_id: @retailer.address.id, 
        destination_id: @tailor.address.id,
        postmates_delivery_id: "del_LYVhhdw8GjKOr-")

      request_body = POSTMATES_WEBHOOK.status_pickup

      post :receive, body: request_body.to_json
      expect(response).to be_success
    end

    context "when the status changes to pickup" do 
      it "updates the status to pickup" do
        FactoryBot.create(
          :postmates_delivery, 
          status: "pending",
          orders: [@order],
          source_id: @retailer.address.id, 
          destination_id: @tailor.address.id,
          postmates_delivery_id: "del_LYVhhdw8GjKOr-")

        request_body = POSTMATES_WEBHOOK.status_pickup

        post :receive, body: request_body.to_json
        expect(Shipment.last.status).to eq("pickup")
      end
    end

    context "when the status changes to pickup_complete" do 
      it "updates the status to pickup_complete" do
        shipment_count = Shipment.count

        FactoryBot.create(
          :postmates_delivery, 
          status: "pickup",
          orders: [@order],
          source_id: @retailer.address.id, 
          destination_id: @tailor.address.id,
          postmates_delivery_id: "del_LYVhhdw8GjKOr-")

        request_body = POSTMATES_WEBHOOK.status_pickup_complete

        post :receive, body: request_body.to_json
        expect(Shipment.last.status).to eq("pickup_complete")
      end
    end
  end
end
