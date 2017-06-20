class Shipment < ApplicationRecord
  validates :type, presence: true
  belongs_to :order
end
