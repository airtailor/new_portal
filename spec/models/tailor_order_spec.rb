require 'rails_helper'

RSpec.describe TailorOrder, type: :model do

  # it "is invalid without a retailer" do
  #   invalid_shoppify_tailor_order = FactoryGirl.build(:shoppify_tailor_order, retailer: nil)
  #   expect(invalid_shoppify_tailor_order).to be_invalid
  # end

  it "is invalid without a tailor" do
    valid_retailer= FactoryGirl.create(:retailer)
    invalid_shoppify_tailor_order = FactoryGirl.build(:shoppify_tailor_order, tailor: nil, retailer: valid_retailer)
    expect(invalid_shoppify_tailor_order).to be_invalid
  end

  context "when the order is from shoppify" do
    before :each do
      company = FactoryGirl.create(:company, name: "Air Tailor")
      FactoryGirl.create(:retailer, name: "Air Tailor", company: company)
    end

    it "has shoppify as it's source by default" do
      valid_shoppify_tailor_order = FactoryGirl.create(:shoppify_tailor_order)
      expect(valid_shoppify_tailor_order.source).to eq("shoppify")
    end
  end
end
