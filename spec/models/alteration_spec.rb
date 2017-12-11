require 'rails_helper'

RSpec.describe Alteration, type: :model do
  it "is invalid without a name" do
    expect(FactoryBot.build(:alteration, name: nil)).to be_invalid
  end

  it "cannot use the same name twice" do
    FactoryBot.create(:alteration, name: "Shorten Sleeves")
    expect(FactoryBot.build(:alteration, name: "Shorten Sleeves")).to be_invalid
  end
end
