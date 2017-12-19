require 'rails_helper'

RSpec.describe TextHelper do
  describe "#alert_for_bad_shopify_order" do 
    it "returns an array of Sonar Messages" do 
      order = FactoryBot.create(:order)
      messages = order.alert_for_bad_shopify_order
      expect(messages.length).to eq(2)
      expect(messages.first.text.include?("Sorry to interupt, but an Order Failed!")).to be(true)
    end
  end
end
