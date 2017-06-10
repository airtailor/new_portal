FactoryGirl.define do
  factory :order do
    subtotal { Faker::Number.decimal(2) }
    total { Faker::Number.decimal(3) }
    retailer { FactoryGirl.create(:retailer) }
  end

  factory :shoppify_tailor_order, class: TailorOrder, parent: :order do
    customer { FactoryGirl.create(:shopify_customer) }
    tailor { FactoryGirl.create(:tailor) }
  end

  factory :welcome_kit, class: WelcomeKit, parent: :order do
    customer { FactoryGirl.create(:shopify_customer) }
    source_order_id { Faker::Number(10) }
  end
end
