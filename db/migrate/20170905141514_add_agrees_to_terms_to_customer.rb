class AddAgreesToTermsToCustomer < ActiveRecord::Migration[5.0]
  def change
    add_column :customers, :agrees_to_terms, :boolean
  end
end
