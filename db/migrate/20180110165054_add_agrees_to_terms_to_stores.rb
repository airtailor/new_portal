class AddAgreesToTermsToStores < ActiveRecord::Migration[5.1]
  def change
    add_column :stores, :agrees_to_terms, :boolean, :default => false
  end
end
