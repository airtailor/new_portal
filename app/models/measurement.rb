class Measurement < ApplicationRecord
  belongs_to :customer, inverse_of: :measurement
  after_initialize :default_values

  def default_values
      self.sleeve_length ||= 0.0
      self.shoulder_to_waist ||= 0.0
      self.chest_bust ||= 0.0
      self.upper_torso ||= 0.0
      self.waist ||= 0.0
      self.pant_length ||= 0.0
      self.hips ||= 0.0
      self.thigh ||= 0.0
      self.knee ||= 0.0
      self.calf ||= 0.0
      self.ankle ||= 0.0
      self.back_width ||= 0.0
      self.bicep ||= 0.0
      self.forearm ||= 0.0
      self.inseam ||= 0.0
      self.elbow ||= 0.0
  end
end
