ItemType.create([
  {name: "Pants"},
  {name: "Shirt"},
  {name: "Tie"},
  {name: "Jacket"},
  {name: "Dress"}
])

air_tailor_co = Company.create(name: "Air Tailor")
banana_co = Company.create(name: "Banana Republic")
frame = Company.create(name: "Frame Denim")
steven = Company.create(name: "Steven Alan")
t_nyc = Company.create(name: "Tailoring NYC")

airtailor = FactoryGirl.create(:retailer, name: "Air Tailor", company: air_tailor_co )
tribeca = FactoryGirl.create(:retailer, name: "Steven Alan - Tribeca", company: steven)
soho = FactoryGirl.create(:retailer, name: "Frame Denim - SoHo", company: steven)
tailoring = FactoryGirl.create(:tailor, name: "Tailoring NYC", company: t_nyc)

User.create(email: "test@stevenalan.com", password: "stevenalan", store: tribeca).add_role :retailer
User.create(email: "brian@airtailor.com", password: "airtailor", store: airtailor).add_role(:admin)
User.create(email: "test@framedenim.com", password: "framedenim", store: soho).add_role(:retailer)
User.create(email: "test@tailoringnyc.com", password: "tailoringnyc", store: tailoring).add_role(:tailor)



#5.times do |n|
#  order = FactoryGirl.create(:shopify_tailor_order, tailor: tailoring, retailer: airtailor)
#  #order.set_arrived unless n == 3
#  #order.set_fulfilled if n == 4
#  order.set_late && order.set_arrived if n == 5
#
#  15.times do
#    item = FactoryGirl.create(:item, order: order)
#    alteration = FactoryGirl.create(:alteration)
#    FactoryGirl.create(:alteration_item, item: item, alteration: alteration)
#  end
#end
#
#5.times do
#  order = FactoryGirl.create(:retailer_tailor_order, tailor: nil, retailer: soho, source: soho.name, arrived: true)
#  15.times do
#    item = FactoryGirl.create(:item, order: order)
#    alteration = FactoryGirl.create(:alteration)
#    FactoryGirl.create(:alteration_item, item: item, alteration: alteration)
#  end
#end
#
#
#5.times do
#  order = FactoryGirl.create(:retailer_tailor_order, retailer: tribeca, tailor: nil, source: tribeca.name)
#  5.times do
#    item = FactoryGirl.create(:item, order: order)
#    alteration = FactoryGirl.create(:alteration)
#    FactoryGirl.create(:alteration_item, item: item, alteration: alteration)
#  end
#end
#
## Customer.all.each do |customer|
##   Measurement.create(customer: customer)
## end
#
#20.times do
#  # customer_id = rand(1..Customer.count)
#  # FactoryGirl.create(:welcome_kit, customer_id: customer_id)
#  FactoryGirl.create(:welcome_kit)
#end
