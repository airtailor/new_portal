FactoryBot.define do
  factory :item do
    order { FactoryBot.create(:shopify_tailor_order) }
    item_type { FactoryBot.create(:item_type) }
    name { Faker::Commerce.product_name }
  end
end
