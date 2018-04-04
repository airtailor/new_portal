class AddAcceptsMarketingToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :accepts_marketing, :string
  end
end
