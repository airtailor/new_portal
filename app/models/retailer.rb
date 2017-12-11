class Retailer < Store
  has_many :orders, inverse_of: :retailer,  foreign_key: "requester_id"
  has_many :items, through: :orders
  has_many :alterations, through: :orders
  has_many :payments, :as => :payable
  belongs_to :default_tailor, class_name: 'Tailor'

  def address_type_string
    "retailer"
  end
end
