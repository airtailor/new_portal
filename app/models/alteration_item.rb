class AlterationItem < ApplicationRecord
  validates :item, :alteration, presence: true

  belongs_to :alteration
  belongs_to :item
end
