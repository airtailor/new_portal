FactoryBot.define do
  factory :address do
    street { Faker::Address.street_address }
    street_two { Faker::Address.secondary_address }
    city { Faker::Address.city }
    state_province { Faker::Address.state }
    zip_code { Faker::Address.zip_code }
  end

  factory :tailor_address, class: Address, parent: :address do
    street { "505 W 162 St" }
    street_two { "Apt 2C" } 
    city { "New York" } 
    state_province { "NY" } 
    zip_code { "10031" } 
    address_type { "tailor" }
  end

  factory :retailer_address, class: Address, parent: :address do 
    address_type { "retailer" }
  end

  factory :customer_address, class: Address, parent: :address do 
    address_type { "customer" }
  end
end
