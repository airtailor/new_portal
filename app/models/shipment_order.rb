class ShipmentOrder < ApplicationRecord
  belongs_to :shipment
  belongs_to :order
end
