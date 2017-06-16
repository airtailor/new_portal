FactoryGirl.define do
  factory :shopify_tailor_order_request, class: Hash do
    id { Faker::Number.number(10) }
    email { Faker::Internet.email }
    note { Faker::Hacker.say_something_smart }
    total_price { Faker::Commerce.price }
    subtotal_price { Faker::Commerce.price }
    total_weight { Faker::Number.number(3) }
    total_discounts { Faker::Commerce.price }
    total_line_items_price { Faker::Commerce.price }
    name { "##{ Faker::Number.number(4) }" }

    line_items { FactoryGirl.build_list(:line_item, 5) }
    customer { FactoryGirl.build(:api_shopify_customer) }
    skip_create
    initialize_with { attributes }
  end

  factory :shopify_welcome_kit, class: Hash, parent: :shopify_tailor_order_request do
    line_items { FactoryGirl.build_list(:line_item, 5, title: "Air Tailor Welcome Kit") }
  end
end

