FactoryGirl.define do
  factory :alteration do
    alteration_type { FactoryGirl.create(:alteration_type) }
    items { [FactoryGirl.create(:items)] } 
  end
end
