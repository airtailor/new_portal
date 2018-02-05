require 'rails_helper'

RSpec.describe Customer, type: :model do
  before :each do
    @co = FactoryBot.create(:company, name: "Air Tailor")
    @airtailor= FactoryBot.create(:retailer, name: "Air Tailor", company: @co)
  end

  it "is invalid without an email" do 
    invalid_customer = FactoryBot.build(:customer, email: nil)
    expect(invalid_customer).to be_invalid
  end

  it "is invalid without a phone" do 
    invalid_customer = FactoryBot.build(:customer, email: nil)
    expect(invalid_customer).to be_invalid
  end

  it "is invalid without a first_name" do 
    invalid_customer = FactoryBot.build(:customer, phone: nil)
    expect(invalid_customer).to be_invalid
  end

  it "is invalid without a last_name" do 
    invalid_customer = FactoryBot.build(:customer, last_name: nil)
    expect(invalid_customer).to be_invalid
  end

  it "is invalid without a unique phone" do 
    valid_customer = FactoryBot.create(:customer)
    invalid_customer = FactoryBot.build(:customer, phone: valid_customer.phone)
    expect(invalid_customer).to be_invalid
  end

  it "is invalid without a unique email" do 
    valid_customer = FactoryBot.create(:customer)
    invalid_customer = FactoryBot.build(:customer, email: valid_customer.email)
    expect(invalid_customer).to be_invalid
  end

  describe "#address" do 
    context "when the customer has an address relation" do 
      it "returns that address" do 
        valid_customer = FactoryBot.create(:customer)
        valid_address = FactoryBot.create(:customer_address)
        valid_customer.addresses.push valid_address
        expect(valid_customer.address.street).to eq(valid_address.street)
      end
    end

    context "when the customer does not have an address relation" do 
      it "returns the address data from the customer table" do 
        valid_customer = FactoryBot.create(:customer)
        expect(valid_customer.address[:street1]).to eq(valid_customer.street1)
      end
    end
  end

end
