# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Company.destroy_all
Store.destroy_all
Alteration.destroy_all
Item.destroy_all
#AlterationItem.destroy_all

air_tailor = Company.create(name: "Air Tailor")
burberry = Company.create(name: "Burberry")
joes = Company.create(name: "Joe's Tailor")

FactoryGirl.create(:retailer, name: "Air Tailor", company: air_tailor )
FactoryGirl.create(:retailer, name: "Burberry 57th St", company: burberry )
joes = FactoryGirl.create(:tailor, name: "Joe's on Main Street", company: joes)

customer = FactoryGirl.create(:shopify_customer)

FactoryGirl.create(:shopify_tailor_order, customer: customer, tailor: joes)

pants = ItemType.create(name: "Pants")
grey_pants = Item.create(name: "Grey Pants", item_type: pants, order: Order.first)
hem = Alteration.create(name: "Hem")
#AlterationItem.create(alteration: hem, item: grey_pants) 
