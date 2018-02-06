require 'rails_helper'

RSpec.describe Store, type: :model do
  it "is invalid without a name" do
    invalid_store = FactoryBot.build(:store, name: nil)
    expect(invalid_store).to_not be_valid
  end

  it "is invalid without a phone" do
    invalid_store = FactoryBot.build(:store, phone: nil)
    expect(invalid_store).to_not be_valid
  end

  it "is invalid without a company" do
    invalid_store = FactoryBot.build(:store, company: nil)
    expect(invalid_store).to_not be_valid
  end

  context "when the store is a retail store" do 
    it "is invalid without a default tailor" do 
      invalid_store = FactoryBot.build(:retailer, default_tailor: nil)
      expect(invalid_store).to_not be_valid
    end
  end

end
