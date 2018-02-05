require 'rails_helper'

RSpec.describe Address, type: :model do
  before :each do
    @co = FactoryBot.create(:company, name: "Air Tailor")
    @airtailor= FactoryBot.create(:retailer, name: "Air Tailor", company: @co)
  end

  it "is invalid without a street" do 
    invalid_address = FactoryBot.build(:address, street: nil)
    expect(invalid_address).to be_invalid
  end

  it "is invalid without a city" do 
    invalid_address = FactoryBot.build(:address, city: nil)
    expect(invalid_address).to be_invalid
  end

  it "is invalid without a state" do 
    invalid_address = FactoryBot.build(:address, state_province: nil)
    expect(invalid_address).to be_invalid
  end

  it "is invalid without a country" do 
    invalid_address = FactoryBot.build(:address, country: nil)
    expect(invalid_address).to be_invalid
  end

  it "is invalid without a country code" do 
    invalid_address = FactoryBot.build(:address, country_code: nil)
    expect(invalid_address).to be_invalid
  end

  describe "#postmates_address" do 
    it "returns an address string formatted for postmates" do 
      valid_address = FactoryBot.build(:address)
      postmates_address = valid_address.postmates_address
      street = valid_address.street
      city = valid_address.city
      state_province = valid_address.state_province
      expect(postmates_address).to eq("#{street}, #{city}, #{state_province}")
    end
  end

  describe "#shippo_address" do
    it "always has the name 'Air Tailor' if the address is a tailor shop" do
      tailor = FactoryBot.create(:tailor)
      shippo_address = tailor.address.shippo_address
      expect(shippo_address[:name]).to eq("Air Tailor")
    end
  end
end
