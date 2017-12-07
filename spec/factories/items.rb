FactoryBot.define do
  factory :item do
    order { FactoryBot.create(:shopify_tailor_order) }
    item_type { ItemType.all.sample }
    name { Faker::Commerce.product_name }
  end
end
