class Alteration < ApplicationRecord
  has_many :alteration_items
  has_many :items, through: :alteration_items
  validates :name, uniqueness: true, presence: true
end
