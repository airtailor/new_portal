class Alteration < ApplicationRecord
  has_many :items, through: :alteration_items
end
