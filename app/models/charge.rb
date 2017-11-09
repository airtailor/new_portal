class Charge < ApplicationRecord
  include PaymentHelper

  belongs_to :chargable, :polymorphic => true
  belongs_to :payable, :polymorphic => true

  validates :chargable, :payable, :amount, presence: true
end
