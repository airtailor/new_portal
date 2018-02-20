FactoryBot.define do
  factory :store do
    name  { Faker::Company.name}
    company { FactoryBot.create(:company) }
    phone { Faker::Number.number(10) }
    street1 "624 W 139th St"
    street2 "Apt 1A"
    city "New York"
    state "New York"
    zip "10031"
    country "US"
    address_id { FactoryBot.create(:address).id }
  end

  factory :hq, class: Headquarters, parent: :store do
  end

  factory :retailer, class: Retailer, parent: :store do
    address { FactoryBot.create(:retailer_address) }
    default_tailor Tailor.first
  end

  factory :tailor, class: Tailor, parent: :store do
    address { FactoryBot.create(:tailor_address) }
  end
end
