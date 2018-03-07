FactoryBot.define do
  factory :ecommerce_order_request, class: Hash do
    source { "E-commerce" }
    retailer { FactoryBot.create(:retailer, name: "Air Tailor") }
    source_order_id { Faker::Number.number(4) }
    requester_notes { Faker}
    customer { FactoryBot.build(:ecommerce_customer) }
    skip_create
    initialize_with { attributes }
  end
end
