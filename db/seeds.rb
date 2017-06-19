Company.destroy_all
User.destroy_all
Store.destroy_all
Order.destroy_all
Alteration.destroy_all
Item.destroy_all

air_tailor_co = Company.create(name: "Air Tailor")
burberry = Company.create(name: "Burberry")
joes = Company.create(name: "Joe's Tailor")
janes = Company.create(name: "Jane's Tailor")

airtailor = FactoryGirl.create(:retailer, name: "Air Tailor", company: air_tailor_co )
FactoryGirl.create(:retailer, name: "Burberry 57th St", company: burberry )
joes = FactoryGirl.create(:tailor, name: "Joe's on Main Street", company: joes)
janes = FactoryGirl.create(:tailor, name: "Jane's on Ave A", company: janes)

joe = User.create(email: "joe@joestailor.com", password: "joejoejoe", store: joes)
joe.add_role :tailor

jane = User.create(email: "jane@janestailor.com", password: "janejanejane", store: janes)
jane.add_role :tailor

brian = User.create(email: "brian@airtailor.com", password: "airtailor", store: airtailor)
brian.add_role :admin

5.times do
  order = FactoryGirl.create(:shopify_tailor_order, tailor: joes, retailer: airtailor)
  5.times do 
    item = FactoryGirl.create(:item, order: order)
    alteration = FactoryGirl.create(:alteration)
    FactoryGirl.create(:alteration_item, item: item, alteration: alteration)
  end
end

5.times do
  order = FactoryGirl.create(:shopify_tailor_order, tailor: janes, retailer: airtailor)
  5.times do 
    item = FactoryGirl.create(:item, order: order)
    alteration = FactoryGirl.create(:alteration)
    FactoryGirl.create(:alteration_item, item: item, alteration: alteration)
  end
end

5.times do
  order = FactoryGirl.create(:shopify_tailor_order, retailer: airtailor, tailor: nil)
  5.times do 
    item = FactoryGirl.create(:item, order: order)
    alteration = FactoryGirl.create(:alteration)
    FactoryGirl.create(:alteration_item, item: item, alteration: alteration)
  end
end
