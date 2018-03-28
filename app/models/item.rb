class Item < ApplicationRecord
  has_many :alteration_items
  has_many :alterations, through: :alteration_items

  belongs_to :item_type
  belongs_to :order

  validates :name, :order, :item_type, presence: true

  def self.create_items_portal(order, items)
    airtailor_message = "Congrats :) An order with #{items.count} items" +
      " was just placed at #{order.retailer.name} for $#{order.total}!"

    phone_list = ["9045668701", "6167804457", "9172321594", "6179607490", "9283008567"]
    phone_list.each do |phone|
      SendSonar.message_customer(text: airtailor_message, to: phone)
    end

    items.each do |item|
      item_name = item["title"].tr('^A-Za-z', '') || item[:title].tr('^A-Za-z', '')
      item_type = grab_item_type_from_title(item_name)
      new_item = self.create(name: item_name, item_type: item_type, order: order)


      item[:alterations].each do |alt|
        title = alt[:title] || alt[:variant_title]
        alteration = find_or_create_alteration(title)
        find_or_create_alteration_item(alteration, new_item)
      end
    end
  end

  def self.remove_number_from_item_name(item_name_with_number)
    item_name_with_number.split(" ")[0..-2].join(" ")
  end

  private

  def self.grab_item_type_from_title(title)
    ItemType.find_or_create_by(name: title)
  end

  def self.get_alteration_name(variant_title, item_name)
    variant_title.split("#{item_name.split(" ")[0]} ").second
  end

  def self.find_or_create_alteration(alteration_name)
    Alteration.find_or_create_by(name: alteration_name)
  end

  def self.find_or_create_alteration_item(alteration, new_item)
    AlterationItem.find_or_create_by(alteration: alteration, item: new_item)
  end
end
