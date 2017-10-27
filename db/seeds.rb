Message.destroy_all if Message.count > 0
Shipment.destroy_all if Shipment.count > 0
User.destroy_all if User.count > 0
Order.destroy_all if Order.count > 0
Store.destroy_all if Store.count > 0
Company.destroy_all if Company.count > 0

Measurement.destroy_all if Measurement.count > 0
Customer.destroy_all if Customer.count > 0

Alteration.destroy_all if Alteration.count > 0
Item.destroy_all if Item.count > 0
ItemType.destroy_all if ItemType.count > 0

ItemType.create([
  {name: "Pants"},
  {name: "Shirt"},
  {name: "Tie"},
  {name: "Jacket"},
  {name: "Dress"}
])


air_tailor_co = Company.create(name: "Air Tailor")
banana_co = Company.create(name: "Banana Republic")
frame_denim_co = Company.create(name: "Frame Denim")
steven_alan_co = Company.create(name: "Steven Alan")
t_nyc = Company.create(name: "Tailoring NYC")

airtailor = FactoryGirl.create(:retailer, name: "Air Tailor", company: air_tailor_co )
steven_alan_tribeca_retailer = FactoryGirl.create(:retailer, name: "Steven Alan - Tribeca", company: steven_alan_co)
steven_alan_soho_retailer = FactoryGirl.create(:retailer, name: "Frame Denim - SoHo", company: steven_alan_co)
t_nyc_tailor = FactoryGirl.create(:tailor, name: "Tailoring NYC", company: t_nyc)

steven_alan_user = User.create(
  email: "test@stevenalan.com",
  password: "stevenalan",
  store: steven_alan_tribeca_retailer
)
stevenalan_user.add_role :retailer

frame_user = User.create(email: "test@framedenim.com", password: "framedenim", store: soho)
frame_user.add_role :retailer

brian = User.create(email: "brian@airtailor.com", password: "airtailor", store: airtailor)
brian.add_role :admin

tailor = User.create(email: "test@tailoringnyc.com", password: "tailoringnyc", store: tailoring)
tailor.add_role :tailor

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
