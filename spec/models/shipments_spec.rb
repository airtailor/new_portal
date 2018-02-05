require 'rails_helper'

RSpec.describe Shipment, type: :model do
  it "is invalid without any orders" do
    invalid_shipment = FactoryBot.build(:shipment, orders: [])
    expect(invalid_shipment).to be_invalid
  end

  it "is invalid without a delivery_type" do
    invalid_shipment = FactoryBot.build(:shipment, delivery_type: nil)
    expect(invalid_shipment).to be_invalid
  end

  it "is invalid without a weight" do
    shipment = FactoryBot.build(:shipment, weight: nil)
    expect(shipment).to be_invalid
  end

  context "when delivery_type is mail_delivery" do 
    it "is invalid without a shipping label" do
      invalid_shipment = FactoryBot.build(:mail_delivery, shipping_label: nil)
      expect(invalid_shipment).to be_invalid
    end

    it "is invalid without a tracking number" do
      invalid_shipment = FactoryBot.build(:mail_delivery, tracking_number: nil)
      expect(invalid_shipment).to be_invalid
    end
  end

  context "when delivery_type is messenger_delivery" do 
    it "is invalid without a postmates_delivery_id" do
      invalid_shipment = FactoryBot.build(:messenger_delivery, postmates_delivery_id: nil)
      expect(invalid_shipment).to be_invalid
    end

    it "is invalid without a status" do
      invalid_shipment = FactoryBot.build(:messenger_delivery, status: nil)
      expect(invalid_shipment).to be_invalid
    end
  end
end
