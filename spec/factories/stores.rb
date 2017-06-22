FactoryGirl.define do
  factory :store do
    name  { Faker::Company.name}
    company { FactoryGirl.create(:company) }
    #primary_contact { FactoryGirl.create(:user) }
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

  factory :hq, class: Headquarters, parent: :store do
  end

  factory :retailer, class: Retailer, parent: :store do
  end

  factory :tailor, class: Tailor, parent: :store do
  end
end

