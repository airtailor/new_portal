FactoryGirl.define do
  factory :shopify_tailor_order_request, class: Hash do
    id { Faker::Number.number(10) }
    email { Faker::Internet.email }
    note { Faker::Hacker.say_something_smart }
    total_price { Faker::Commerce.price }
    subtotal_price { Faker::Commerce.price }
    total_weight { Faker::Number.number(3) }
    total_discounts { Faker::Commerce.price }
    total_line_items_price { Faker::Commerce.price }
    name { "##{ Faker::Number.number(4) }" }

    line_items { FactoryGirl.build_list(:line_item, 5) }
    customer { FactoryGirl.build(:api_shopify_customer) }
    skip_create
    initialize_with { attributes }

#     "customer": {
#         "id": 4337768393,
#         "email": "brian@airtailor.com",
#         "accepts_marketing": true,
#         "created_at": "2016-10-14T14:26:20-04:00",
#         "updated_at": "2017-06-07T18:14:39-04:00",
#         "first_name": "Brian",
#         "last_name": "Flynn",
#         "orders_count": 84,
#         "state": "disabled",
#         "total_spent": "1514.80",
#         "last_order_id": 4940519369,
#         "note": null,
#         "verified_email": true,
#         "multipass_identifier": null,
#         "tax_exempt": false,
#         "phone": null,
#         "tags": "",
#         "last_order_name": "#6356",
#         "default_address": {
#             "id": 5561308297,
#             "first_name": "Brian",
#             "last_name": "Flynn",
#             "company": "Air Tailor",
#             "address1": "415 Madison Ave.",
#             "address2": "4th Floor",
#             "city": "New York",
#             "province": "New York",
#             "country": "United States",
#             "zip": "10017",
#             "phone": "(616) 780-4457",
#             "name": "Brian Flynn",
#             "province_code": "NY",
#             "country_code": "US",
#             "country_name": "United States",
#             "default": true
#         }
#     }
# }

#"billing_address": {
    #     "first_name": "Brian",
    #     "address1": "415 Madison Ave.",
    #     "phone": "(616) 780-4457",
    #     "city": "New York",
    #     "zip": "10017",
    #     "province": "New York",
    #     "country": "United States",
    #     "last_name": "Flynn",
    #     "address2": "4th Floor",
    #     "company": "Air Tailor",
    #     "latitude": 40.7567112,
    #     "longitude": -73.9760848,
    #     "name": "Brian Flynn",
    #     "country_code": "US",
    #     "province_code": "NY"
    # },
    # "shipping_address": {
    #     "first_name": "Brian",
    #     "address1": "415 Madison Ave.",
    #     "phone": "(616) 780-4457",
    #     "city": "New York",
    #     "zip": "10017",
    #     "province": "New York",
    #     "country": "United States",
    #     "last_name": "Flynn",
    #     "address2": "4th Floor",
    #     "company": "Air Tailor",
    #     "latitude": 40.7567112,
    #     "longitude": -73.9760848,
    #     "name": "Brian Flynn",
    #     "country_code": "US",
    #     "province_code": "NY"
    # },
  end
end
#FactoryGirl.create(:api_response)
#=>  { "id" => "someRandomID", "name" => "someRandomName", "start_date" => "2017-01-01" }
