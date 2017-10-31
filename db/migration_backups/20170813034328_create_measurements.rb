class CreateMeasurements < ActiveRecord::Migration[5.0]
  def change
    create_table :measurements do |t|
      t.float :sleeve_length
      t.float :shoulder_to_waste
      t.float :chest_bust
      t.float :upper_torso
      t.float :waist
      t.float :pant_length
      t.float :hips
      t.float :thigh
      t.float :knee
      t.float :calf
      t.float :ankle
      t.float :back_width
      t.float :bicep
      t.float :forearm
      t.float :inseam
      t.references :customer, foreign_key: true

      t.timestamps
    end
  end
end
