require 'rails_helper'

RSpec.describe Item, type: :model do
  it "is invalid without an item_type" do
    invalid_item = FactoryGirl.build(:item, item_type: nil)
    expect(invalid_item).to be_invalid
  end

  it "is invalid without a name" do
    invalid_item = FactoryGirl.build(:item, name: nil)
    expect(invalid_item).to be_invalid
  end

  it "is invalid without an order" do
    invalid_item = FactoryGirl.build(:item, order: nil)
    expect(invalid_item).to be_invalid
  end
end
