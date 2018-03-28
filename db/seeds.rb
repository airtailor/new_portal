#["Pants", "Shirt", "Tie", "Jacket", "Dress"].each do |type|
#  ItemType.find_or_create_by(name: type)
#end
#
#[ {
#    role: :retailer, name: "Air Tailor",  store_name: "Air Tailor", phone: "6302352554",
#    email: "brian@airtailor.com", password: 'airtailor'
#  }, {
#    role: :retailer, name: "Banana Republic",  store_name: "Banana Republic", phone: "6302352554",
#    email: "test@bananarepublic.com", password: 'bananarepublic'
#  }, {
#    role: :retailer, name: "Frame Denim",  store_name: "Frame Denim - Soho", phone: "6302352554",
#    email: "test@framedenim.com", password: 'framedenim'
#  }, {
#    role: :retailer, name: "Steven Alan",  store_name: "Steven Alan - Tribeca", phone: "6302352554",
#    email: "test@stevenalan.com", password: 'stevenalan'
#  }, {
#    role: :tailor, name: "Tailoring NYC",  store_name: "Tailoring NYC", phone: "6302352554",
#    email: "test@tailoringnyc.com", password: 'tailoringnyc'
#  } ].each do |data_hash|
#      company = Company.find_or_create_by(name: data_hash[:name])
#      unless company.stores.first
#        store = FactoryBot.create(
#          data_hash[:role],
#          name: data_hash[:store_name],
#          phone: data_hash[:phone],
#          company: data_hash[:company]
#        )
#      end
#
#      unless User.where(name: data_hash[:name]).first
#        usr = User.create(
#          email: data_hash[:email],
#          password: data_hash[:password],
#          store: store
#        )
#        usr.add_role(data_hash[:role])
#      end
#
#    end
#
##5.times do |n|
##  order = FactoryBot.create(:shopify_tailor_order, tailor: tailoring, retailer: airtailor)
##  #order.set_arrived unless n == 3
##  #order.set_fulfilled if n == 4
##  order.set_late && order.set_arrived if n == 5
##
##  15.times do
##    item = FactoryBot.create(:item, order: order)
##    alteration = FactoryBot.create(:alteration)
##    FactoryBot.create(:alteration_item, item: item, alteration: alteration)
##  end
##end
##
##5.times do
##  order = FactoryBot.create(:retailer_tailor_order, tailor: nil, retailer: soho, source: soho.name, arrived: true)
##  15.times do
##    item = FactoryBot.create(:item, order: order)
##    alteration = FactoryBot.create(:alteration)
##    FactoryBot.create(:alteration_item, item: item, alteration: alteration)
##  end
##end
##
##
##5.times do
##  order = FactoryBot.create(:retailer_tailor_order, retailer: tribeca, tailor: nil, source: tribeca.name)
##  5.times do
##    item = FactoryBot.create(:item, order: order)
##    alteration = FactoryBot.create(:alteration)
##    FactoryBot.create(:alteration_item, item: item, alteration: alteration)
##  end
##end
##
### Customer.all.each do |customer|
###   Measurement.create(customer: customer)
### end
##
##20.times do
##  # customer_id = rand(1..Customer.count)
##  # FactoryBot.create(:welcome_kit, customer_id: customer_id)
##  FactoryBot.create(:welcome_kit)
##end
