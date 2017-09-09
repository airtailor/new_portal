require 'rails_helper'

RSpec.describe Item, type: :model do
  before :each do
    co = FactoryGirl.create(:company, name: "Air Tailor")
    FactoryGirl.create(:retailer, name: "Air Tailor", company: co)
  end

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

  # describe "#create_items_for" do
  # 	it "adds items to the correct order" do
  #     order = FactoryGirl.create(:shopify_tailor_order)
  #     item_list = (0..2).map do
  #       FactoryGirl.create(:item, order: order)
  #     end
  #     expect(Order.last.items).to eq(item_list)
  #   end


  # 	it "adds the correct alterations for an item" do
  #     order = FactoryGirl.create(:shopify_tailor_order)
  #     item_list = (0..2).map do
  #       FactoryGirl.create(:item, order: order)
  #     end
  #     expect(Order.last.items.first.alterations).to eq(item_list.first.alterations)
  #   end
  # end

end
