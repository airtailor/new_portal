class AddElbowToMeasurements < ActiveRecord::Migration[5.0]
  def change
    add_column :measurements, :elbow, :float
    remove_column :measurements, :shoulder_to_waste, :float
    add_column :measurements, :shoulder_to_waist, :float
  end
end
