FactoryGirl.define do
  factory :customer do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    phone { Faker::Number.number(10) }
    #street1 { Faker::Address.street_address }
    #street2 { Faker::Address.secondary_address }
    #city { Faker::Address.city }
    #state { Faker::Address.state }
    #zip { Faker::Address.zip }
    #country { Faker::Address.country }
    street1 "624 W 139th St"
    street2 "Apt 1A"
    city "New York"
    state "New York"
    zip "10031"
    country "US"
  end

  factory :shopify_customer, class: Customer, parent: :customer do
    shopify_id { Faker::Number.number(8) }
  end
end

