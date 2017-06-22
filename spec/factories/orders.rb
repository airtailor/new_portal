FactoryGirl.define do
  factory :order do
    subtotal { Faker::Number.decimal(2) }
    total { Faker::Number.decimal(3) }
    customer { FactoryGirl.create(:shopify_customer) }
    retailer { FactoryGirl.create(:retailer, name: "Air Tailor") }
    source_order_id { Faker::Number.number(4) }
    weight { Faker::Number.number(3) }
  end

  factory :welcome_kit, class: WelcomeKit, parent: :order do
  end

  factory :shopify_tailor_order, class: TailorOrder, parent: :order do
    tailor { FactoryGirl.create(:tailor) }
  end
end

