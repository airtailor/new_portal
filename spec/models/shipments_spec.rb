require 'rails_helper'

RSpec.describe Shipment, type: :model do
  it "is invalid without an order" do 
    shipment = FactoryGirl.build(:shipment, order: nil) 
    expect(shipment).to be_invalid
  end

  it "is invalid without a type" do 
    shipment = FactoryGirl.build(:shipment, type: nil)
    expect(shipment).to be_invalid
  end

  it "is valid with valid attributes" do 
    shipment = FactoryGirl.build(:shipment)
    expect(shipment).to be_valid
  end
end
