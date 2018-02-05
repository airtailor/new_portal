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
end
