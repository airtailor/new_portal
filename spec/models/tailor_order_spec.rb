require 'rails_helper'

RSpec.describe TailorOrder, type: :model do
  before :each do
    co = FactoryBot.create(:company, name: "Air Tailor")
    FactoryBot.create(:retailer, name: "Air Tailor", company: co)
  end

  it "is valid without a tailor" do
    valid_retailer= FactoryBot.create(:retailer)
    invalid_shopify_tailor_order = FactoryBot.build(:shopify_tailor_order, tailor: nil, retailer: valid_retailer)
    expect(invalid_shopify_tailor_order).to be_valid
  end

  it "is valid with a tailor" do
    valid_retailer= FactoryBot.create(:retailer)
    valid_tailor = FactoryBot.create(:tailor)
    invalid_shopify_tailor_order = FactoryBot.build(:shopify_tailor_order, tailor: valid_tailor, retailer: valid_retailer)
    expect(invalid_shopify_tailor_order).to be_valid
  end

  # describe "has relationships with tailor, items, alterations" do
  #   before :each do
  #      valid_tailor_order = FactoryBot.create(:shopify_tailor_order)
  #      5.times do
  #       FactoryBot.create(:item, order: valid_tailor_order)
  #     end
  #   end

  #   it "has a relationship with tailor" do
  #     expect(TailorOrder.last.tailor).to eq(Tailor.last)
  #   end

  #   it "has a relationship with items" do
  #     expect(TailorOrder.last.items).to eq(Item.all)
  #   end

  #   it "has a relationship with alterations" do
  #     Item.all.each do |item|
  #       alt = FactoryBot.create(:alteration)
  #       FactoryBot.create(:alteration_item, item: item, alteration: alt)
  #     end
  #     expect(TailorOrder.last.alterations).to eq(Alteration.all)
  #   end
  # end
end
