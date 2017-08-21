
Shipment.destroy_all
User.destroy_all
Order.destroy_all
Store.destroy_all
Company.destroy_all

Measurement.destroy_all
Customer.destroy_all

Alteration.destroy_all
Item.destroy_all
ItemType.destroy_all

ItemType.create([
  {name: "Pants"},
  {name: "Shirt"},
  {name: "Tie"},
  {name: "Jacket"},
  {name: "Dress"}
])


air_tailor_co = Company.create(name: "Air Tailor")
banana_co = Company.create(name: "Banana Republic")
joes = Company.create(name: "Joe's Tailor")
janes = Company.create(name: "Jane's Tailor")

airtailor = FactoryGirl.create(:retailer, name: "Air Tailor", company: air_tailor_co )
banana = FactoryGirl.create(:retailer, name: "Tribeca", company: banana_co )
joes = FactoryGirl.create(:tailor, name: "Joe's on Main Street", company: joes)
janes = FactoryGirl.create(:tailor, name: "Jane's on Ave A", company: janes)

joe = User.create(email: "joe@joestailor.com", password: "joejoejoe", store: joes)
joe.add_role :tailor

jane = User.create(email: "jane@janestailor.com", password: "janejanejane", store: janes)
jane.add_role :tailor

brian = User.create(email: "brian@airtailor.com", password: "airtailor", store: airtailor)
brian.add_role :admin

allen = User.create(email: "allen@bananarepublic.com", password: "allenallen", store: banana)
allen.add_role :retailer

5.times do |n|
  order = FactoryGirl.create(:shopify_tailor_order, tailor: joes, retailer: airtailor)
  #order.set_arrived unless n == 3
  #order.set_fulfilled if n == 4
  order.set_late && order.set_arrived if n == 5

  15.times do
    item = FactoryGirl.create(:item, order: order)
    alteration = FactoryGirl.create(:alteration)
    FactoryGirl.create(:alteration_item, item: item, alteration: alteration)
  end
end

5.times do
  order = FactoryGirl.create(:retailer_tailor_order, tailor: janes, retailer: banana, source: banana.name, arrived: true)
  15.times do
    item = FactoryGirl.create(:item, order: order)
    alteration = FactoryGirl.create(:alteration)
    FactoryGirl.create(:alteration_item, item: item, alteration: alteration)
  end
end


5.times do
  order = FactoryGirl.create(:retailer_tailor_order, retailer: banana, tailor: nil, source: banana.name)
  5.times do
    item = FactoryGirl.create(:item, order: order)
    alteration = FactoryGirl.create(:alteration)
    FactoryGirl.create(:alteration_item, item: item, alteration: alteration)
  end
end

Customer.all.each do |customer|
  Measurement.create(customer: customer)
end

20.times do
  # customer_id = rand(1..Customer.count)
  # FactoryGirl.create(:welcome_kit, customer_id: customer_id)
  FactoryGirl.create(:welcome_kit)
end
