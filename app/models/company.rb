class Company < ApplicationRecord
  validates :name, presence: true

  belongs_to :hq_store, class_name: "Headquarters", primary_key: "hq_store_id", optional: true

  has_many :stores

end
