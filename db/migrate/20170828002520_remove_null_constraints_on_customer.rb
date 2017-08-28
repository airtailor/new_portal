class RemoveNullConstraintsOnCustomer < ActiveRecord::Migration[5.0]
  def change
    change_column_null :customers, :street1, true
    change_column_null :customers, :street2, true
    change_column_null :customers, :city, true
    change_column_null :customers, :state, true
    change_column_null :customers, :zip, true
  end
end
