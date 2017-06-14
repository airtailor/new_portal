require 'rails_helper'

RSpec.describe Api::ShopifyController, type: :controller do

  describe "POST #receive" do
    it "creates a new order" do
      request_body = FactoryGirl.build(:shopify_tailor_order_request)
      post :receive, request_body.to_json
      byebug
    end
  end
end
