FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "slayer#{n}@rules.duh" }
    password Faker::Internet.password(8)
  end
end
