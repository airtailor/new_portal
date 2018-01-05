FactoryBot.define do
  factory :shipment do
    orders { FactoryBot.create(:order) }
    weight { "#{Faker::Number.number(3)}" }
    shipping_label { "#{Faker::LoremPixel.image("300x300", false, 'sports')}" }
    tracking_number { "#{Faker::Number.number(10)}" }
  end

  factory :postmates_delivery, class: Shipment, parent: :shipment do
    tracking_number nil
    shipping_label nil
    postmates_delivery_id "xyz"
    source_id 2
    source_type "Address"
    destination_type "Address"
    destination_id 3 
    weight { Faker::Number.number(2) }
    delivery_type "messenger_shipment"
    status "pending"
  end
end
