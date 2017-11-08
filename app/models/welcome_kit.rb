class WelcomeKit < Order
  def set_default_fields
    super

    self.weight = 28
    self.fulfilled = true
  end
end
