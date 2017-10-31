["Pants", "Shirt", "Tie", "Jacket", "Dress"].each do |type|
  ItemType.find_or_create_by(name: type)
end

[ {
    role: :retailer, name: "Air Tailor", phone: "630 235 2554",
    email: "brian@airtailor.com", password: 'airtailor'
  }, {
    role: :retailer, name: "Banana Republic", phone: "630 235 2554",
    email: "test@bananarepublic.com", password: 'bananarepublic'
  }, {
    role: :retailer, name: "Frame Denim - Soho", phone: "630 235 2554",
    email: "test@framedenim.com", password: 'framedenim'
  }, {
    role: :retailer, name: "Steven Alan -  Tribeca", phone: "630 235 2554",
    email: "test@stevenalan.com", password: 'stevenalan'
  }, {
    role: :tailor, name: "Tailoring NYC", phone: "630 235 2554",
    email: "test@tailoringnyc.com", password: 'tailoringnyc'
  } ].each do |data_hash|
      company = Company.find_or_create_by(name: data_hash[:name])
      factory_girl_params = [
        data_hash[:role],
        data_hash[:name],
        data_hash[:phone],
        company
      ]
      store = FactoryGirl.create(
        data_hash[:role],
        name: data_hash[:name],
        phone: data_hash[:phone]
        company: data_hash[:company]
      )

      usr = User.find_or_create_by(
        email: data_hash[:email],
        password: data_hash[:password],
        store: store
      )

      usr.add_role(data_hash[:role])
    end

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
