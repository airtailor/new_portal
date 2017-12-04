# require 'rails_helper'

# RSpec.describe Shipment, type: :model do
#   it "is invalid without an order" do
#     shipment = FactoryBot.build(:shipment, order: nil)
#     expect(shipment).to be_invalid
#   end

#   it "is invalid without a type" do
#     shipment = FactoryBot.build(:shipment, type: nil)
#     expect(shipment).to be_invalid
#   end

#   it "is invalid without a shipping label" do
#     shipment = FactoryBot.build(:shipment, shipping_label: nil)
#     expect(shipment).to be_invalid
#   end

#   it "is invalid without a weight" do
#     shipment = FactoryBot.build(:shipment, weight: nil)
#     expect(shipment).to be_invalid
#   end

#   it "is invalid without a tracking number" do
#     shipment = FactoryBot.build(:shipment, tracking_number: nil)
#     expect(shipment).to be_invalid
#   end

#   it "is valid with valid attributes" do
#     shipment = FactoryBot.build(:shipment)
#     expect(shipment).to be_valid
#   end
# end
