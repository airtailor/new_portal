class AddNameAndRemoveAlterationTypeFromAlterations < ActiveRecord::Migration[5.0]
  def change
    remove_column :alterations, :alteration_type, :integer
    add_column :alterations, :name, :string
  end
end
