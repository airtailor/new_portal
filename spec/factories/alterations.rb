FactoryGirl.define do
  factory :alteration do
    sequence(:name){|n| "alteration #{n}" }
  end
end
