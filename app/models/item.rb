class Item < ApplicationRecord
  has_many :alterations, through: :alteration_items
  belongs_to :item_type, class_name: "ItemType", foreign_key: "type_id"
  belongs_to :order
end
