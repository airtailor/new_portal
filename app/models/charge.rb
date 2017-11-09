class Charge < ApplicationRecord
  belongs_to :chargable, :polymorpic => true
  belongs_to :payable, :polymorphic => true

end
