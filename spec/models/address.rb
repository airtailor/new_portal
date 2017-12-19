require 'rails_helper'

RSpec.describe Address, type: :model do
  before :each do
    @co = FactoryBot.create(:company, name: "Air Tailor")
    @airtailor= FactoryBot.create(:retailer, name: "Air Tailor", company: @co)
  end

  describe "#shippo_address" do
    it "always has the name 'Air Tailor' if the address is a tailor shop" do
      tailor = FactoryBot.create(:tailor)
      shippo_address = tailor.address.shippo_address
      expect(shippo_address[:name]).to eq("Air Tailor")
    end
  end
end
