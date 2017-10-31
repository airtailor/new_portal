class AddCompanyToCustomers < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :company, :string
  end
end
