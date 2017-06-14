FactoryGirl.define do
  factory :alteration_item do
    item { FactoryGirl.create(:item) }
    alteration { FactoryGirl.create(:alteration) }
  end
end
