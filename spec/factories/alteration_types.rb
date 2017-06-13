FactoryGirl.define do
  factory :alteration_type do
    name { ["Hemmed", "Button", "Hole"].sample }
  end
end
