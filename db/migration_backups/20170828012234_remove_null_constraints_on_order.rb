class RemoveNullConstraintsOnOrder < ActiveRecord::Migration[5.0]
  def change
    change_column_null :orders, :subtotal, true
  end
end
