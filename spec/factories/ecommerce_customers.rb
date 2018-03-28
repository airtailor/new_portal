FactoryBot.define do
  factory :ecommerce_customer, class: Hash do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { "9045668701" }
    street { "624 W 139th St" } 
    street_two { "Apt 4F" }
    city { "New York" }
    state_province { "NY" }
    zip_code { "10031" }
    skip_create
    initialize_with { attributes }
  end
end
