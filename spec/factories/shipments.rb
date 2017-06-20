FactoryGirl.define do
  factory :shipment do
    order { FactoryGirl.create(:order) }
    type { ["OutgoingShipment", "IncomingShipment"].sample }
    weight { "#{Faker::Number.number(3)}" }
    shipping_label { "#{Faker::LoremPixel.image("300x300", false, 'sports')}" }
    tracking_number { "#{Faker::Number.number(10)}" }
  end
end
