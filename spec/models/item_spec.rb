require 'rails_helper'

RSpec.describe Item, type: :model do
  before :each do
    co = FactoryBot.create(:company, name: "Air Tailor")
    FactoryBot.create(:retailer, name: "Air Tailor", company: co)
  end

  it "is invalid without an item_type" do
    invalid_item = FactoryBot.build(:item, item_type: nil)
    expect(invalid_item).to be_invalid
  end

  it "is invalid without a name" do
    invalid_item = FactoryBot.build(:item, name: nil)
    expect(invalid_item).to be_invalid
  end

  it "is invalid without an order" do
    invalid_item = FactoryBot.build(:item, order: nil)
    expect(invalid_item).to be_invalid
  end

end
