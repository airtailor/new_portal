require 'rails_helper'

RSpec.describe Company, type: :model do
  it "is invalid without a name" do
    invalid_company = FactoryBot.build(:company, name: nil)
    expect(invalid_company).to_not be_valid
  end

  describe "#hq_store" do
    it "lists the company's hq store if it has one" do
      valid_company = FactoryBot.create(:company)
      valid_hq = FactoryBot.create(:hq, company: valid_company)
      valid_company.hq_store = valid_hq
      expect(valid_company.hq_store).to eq(valid_hq)
    end

    it "will not associate with a store that is not an hq store" do
      valid_company = FactoryBot.create(:company)
      invalid_hq = FactoryBot.create(:store, company: valid_company)
      expect { valid_company.hq_store = invalid_hq }.to raise_error
    end
  end

  describe "#stores" do
    it "lists all the company's stores" do
      valid_company = FactoryBot.create(:company)
      valid_store = FactoryBot.create(:store, company: valid_company)
      expect(valid_company.stores.include?(valid_store)).to be(true)
    end
  end
end
