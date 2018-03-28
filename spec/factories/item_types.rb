FactoryBot.define do
  factory :item_type do
    name { ["Pant", "Shirt", "Socks", "Jacket", "Skirt"].sample }
  end
end
