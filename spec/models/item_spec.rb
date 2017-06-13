require 'rails_helper'

RSpec.describe Item, type: :model do
  it "is invalid without an item_type" do
    invalid_item = FactoryGirl.build(:item, item_type: nil)
    expect(invalid_item).to be_invalid
  end

  it "is invalid without an alteration" do 
    invalid_item = FactoryGirl.build(:item, alterations: nil)
    expect { invalid_item }.to raise_error 
  end
end
