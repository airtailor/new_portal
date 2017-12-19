require 'rails_helper'

RSpec.describe Api::PostmatesController, type: :controller do
  describe "POST #receive" do
    before :each do
      co = FactoryBot.create(:company, name: "Air Tailor")
      FactoryBot.create(:retailer, name: "Air Tailor", company: co)
    end
  end
end

