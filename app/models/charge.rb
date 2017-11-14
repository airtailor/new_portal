class Charge < ApplicationRecord
  include PaymentHelper

  belongs_to :chargable, :polymorphic => true
  belongs_to :payable, :polymorphic => true

  validates :payable, :amount, :stripe_id, presence: true
end
