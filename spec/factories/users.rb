FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password(8) }
    store { FactoryBot.create(:store) }
  end
end
