FactoryBot.define do
  factory :alteration_item do
    item { FactoryBot.create(:item) }
    alteration { FactoryBot.create(:alteration) }
  end
end
