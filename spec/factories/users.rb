FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    store { FactoryGirl.create(:store) }
  end
end
