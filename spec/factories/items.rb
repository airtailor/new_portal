FactoryGirl.define do
  factory :item do
    order { FactoryGirl.create(:shopify_tailor_order) }
    item_type { FactoryGirl.create(:item_type) }
    name { Faker::Commerce.product_name }
    #alterations { |alterations| alterations.association :item }
  end
end
