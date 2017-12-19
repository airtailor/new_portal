FactoryBot.define do
  factory :shipment_order do
    shipment { FactoryGirl.create(:shipment) }
    order { FactoryGirl.create(:order) }
    source { FactoryGirl.create(:address) }
    destination { FactoryGirl.create(:address) }
  end
end
