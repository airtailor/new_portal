class AddHqStoreToCompany < ActiveRecord::Migration[5.0]
  def change
    add_reference :companies, :hq_store, references: :stores, index: true
  end
end
