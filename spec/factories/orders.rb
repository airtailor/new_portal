FactoryGirl.define do
  factory :order do
    subtotal { Faker::Number.decimal(2) }
    total { Faker::Number.decimal(3) }
  end

  factory :welcome_kit, class: WelcomeKit, parent: :order do
    retailer { FactoryGirl.create(:retailer) }
    customer { FactoryGirl.create(:shopify_customer) }
    source_order_id { Faker::Number.number(4) }
  end


  factory :shopify_tailor_order, class: TailorOrder, parent: :order do
    retailer { FactoryGirl.create(:retailer, name: "Air Tailor") }
    customer { FactoryGirl.create(:shopify_customer) }
    tailor { FactoryGirl.create(:tailor) }
  end

end
