require 'rails_helper'

RSpec.describe Store, type: :model do
  it "is invalid without a name" do
    invalid_store = FactoryGirl.build(:store, name: nil)
    expect(invalid_store).to_not be_valid
  end

  it "defaults country to United States if no country provided" do 
    valid_store = FactoryGirl.create(:store, country: nil)
    puts "COUNTRY #{valid_store.country}"
    expect(valid_store.country).to eq("United States")
  end
end
