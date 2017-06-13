class Order < ApplicationRecord
  validates :retailer, presence: true
  belongs_to :retailer, class_name: "Retailer", foreign_key: "requester_id"

end
