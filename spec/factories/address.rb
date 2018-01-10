FactoryBot.define do
  factory :address do
    number { Faker::Address.building_number }
    street { Faker::Address.street_name }
    street_two { Faker::Address.secondary_address }
    city { Faker::Address.city }
    state_province { Faker::Address.state }
    zip_code { Faker::Address.zip_code }
  end

  factory :tailor_address, class: Address, parent: :address do
    address_type { "tailor" }
  end

  factory :retailer_address, class: Address, parent: :address do 
    address_type { "retailer" }
  end
end
