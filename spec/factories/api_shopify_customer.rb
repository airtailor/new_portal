FactoryBot.define do
  factory :api_shopify_customer, class: Hash do
    skip_create

    id { Faker::Number.number(8) }
    email { Faker::Internet.email }

    ignore do
      first_name { Faker::Name.first_name }
      last_name { Faker::Name.last_name }
      company { Faker::Company.name }
      address1 { Faker::Address.street_address }
      address2 { Faker::Address.secondary_address }
      city { Faker::Address.city }
      province { Faker::Address.state }
      zip { Faker::Address.zip }
      country_name { "United States" }
      country_code { "US" }
      phone { Faker::Number.number(10) }
    end

    default_address do
      {
        first_name: first_name,
        last_name: last_name,
        company: company,
        address1: address1,
        address2: address2,
        city: city,
        province: province,
        zip: zip,
        country_name: "United States",
        country_code: "US",
        phone: phone
      }
    end

    initialize_with { attributes }
  end
end
