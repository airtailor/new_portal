require 'rails_helper'

RSpec.describe Alteration, type: :model do
  it "is invalid without a name" do
    expect(FactoryGirl.build(:alteration, name: nil)).to be_invalid
  end

  it "cannot use the same name twice" do
    FactoryGirl.create(:alteration, name: "Shorten Sleeves")
    expect(FactoryGirl.build(:alteration, name: "Shorten Sleeves")).to be_invalid
  end
end
