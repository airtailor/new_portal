require 'rails_helper'

RSpec.describe AlterationItem, type: :model do
  it "is invalid without an item" do
    invalid_alt = FactoryBot.build(:alteration_item, item: nil)
    expect(invalid_alt).to be_invalid
  end

  it "is invalid without an alteration" do
    invalid_alt = FactoryBot.build(:alteration_item, alteration: nil)
    binding.pry
    expect(invalid_alt).to be_invalid
  end
end
